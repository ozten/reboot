var fs = require('fs');

var tokenize = require('./tokenizer.js');

exports.parseFile = function(filename, cb) {
    fs.readFile(filename, {encoding: 'utf8'}, function(err, source) {
  	    if (err) return cb(err);
        tokenize(source, function(err, tokens) {
    	    if (err) return cb(err);
    	    console.log('=========== Tokens ==========');
    	    console.log(tokens);
    	    parseTokens(tokens, cb);
        });
    });
}

function parseTokens(tokens, cb) {
	var state = {
		mode: 'parsingProgram',
		tokenIndex: 0,
		ast: [],
		err: null
	}
    for (state.tokenIndex=0; state.tokenIndex < tokens.length; state.tokenIndex++) {
    	switch (tokens[state.tokenIndex]) {
    		case 'use':
                parseSourceReference(state, tokens);
    		    break;
    		case 'fn':
    		    parseFunctionDeclaration(state, tokens);
    		default:
    		    var currentToken = tokens[state.tokenIndex];
    		    var nextToken = null;
    		    if (state.tokenIndex + 1 < tokens.length) {
    		    	nextToken = tokens[state.tokenIndex + 1];
    		    }
    		    if (false === tokenIsSyntax(currentToken) &&
    		    	'(' === nextToken) {
                    parseFunctionCall(state, tokens);
    		    } else {
    		    	state.err = new Error('Unable to parse... WTF is [' + tokens[state.tokenIndex] + ']');	
    		    }
    		    break;
    	}    	
    	if (state.err) {
    		break;
    	}
    }
    cb(state.err, state.ast);	
}

function parseSourceReference(state, tokens) {
    if (state.tokenIndex + 1 >= tokens.length) {
    	state.err = new Error('Invalid source module. Expected source code after "use".');
    } else if (tokenIsSyntax(tokens[state.tokenIndex + 1]) ||
    	       tokenIsAReservedWord(tokens[state.tokenIndex + 1])){
        state.err = new Error('Invalid source module. Expected source code after "use", but got ' +
        	tokens[state.tokenIndex + 1]);
    } else {
    	state.ast.push({
    		syntax: 'Use',
    		value: tokens[state.tokenIndex + 1]
    	});
    	state.tokenIndex++;
    }
}

function parseFunctionDeclaration(state, tokens) {
	var fnAst = {
		syntax: 'FunctionDeclaration',
		name: null,
		parameters: [],
		body: []
	}
	var minTokens = 5; // foo ( ) { }
	if (state.tokenIndex + minTokens >= tokens.length) {
    	state.err = new Error('Invalid function. Expected name() {} after "fn".');
    } else if (tokenIsSyntax(tokens[state.tokenIndex + 1]) ||
    	       tokenIsAReservedWord(tokens[state.tokenIndex + 1])){
        state.err = new Error('Invalid function module. Expected name after "fn", but got ' +
        	tokens[state.tokenIndex + 1]);
    } else {
        fnAst.name = tokens[state.tokenIndex + 1];
        state.tokenIndex++;
        if ('(' !== tokens[state.tokenIndex + 1]) {
        	state.err = new Error('Invalid function. Expected "(arguments)"');
        	return;
        }
        state.tokenIndex++;
        while (')' !== tokens[state.tokenIndex + 1] &&
        	state.tokenIndex + 1 < tokens.length) {		

        	if (tokenIsSyntax(tokens[state.tokenIndex + 1]) ||
    	       tokenIsAReservedWord(tokens[state.tokenIndex + 1])){
				state.err = new Error('Invalid function parameters.');
        	} else {
        		fnAst.parameters.push(tokens[state.tokenIndex + 1]);
        		state.tokenIndex++;
        	}
        }

        if (state.tokenIndex + 1 >= tokens.length) {
        	state.err = new Error('Invalid function. Expected "(arguments)"');
        	return;
        }
        // token is )
        state.tokenIndex++;
        if ('{' !== tokens[state.tokenIndex + 1]) {
        	state.err = new Error('Invalid function, no body. Expected "fn name(arguments) { }"');
        	return;
        }
        // next token is {
        state.tokenIndex++;
        state.tokenIndex++;
        
        state.mode = 'parsingFnBody';
        state.ast.push(fnAst);
    }   
}

function parseFunctionCall(state, tokens) {
	var fnCallAst = {
		syntax: 'FunctionCall',
		name: null,
		arguments: []
	};
	fnCallAst.name = tokens[state.tokenIndex];
	state.tokenIndex++;

	if ('(' !== tokens[state.tokenIndex]) {
		state.err = new Error('Invalid function call, no "(".');
		return;
	}
	// token is (
	state.tokenIndex++;
	if (')' === tokens[state.tokenIndex]) {
		// oken is )
		state.tokenIndex++;
		state.ast.push(fnCallAst);
	} else {
		fnCallAst.arguments = parseAndReturnFunctionArguments(state, tokens);
		if (state.err) return;
		if (')' !== tokens[state.tokenIndex]) {
			state.err = new Error('Invalid function call, no "(".');
		    return;
	    }
	    // oken is )
		state.tokenIndex++;
		state.ast.push(fnCallAst);
	}
}

function parseAndReturnFunctionArguments(state, tokens) {
	var arguments = [];
	while (state.tokenIndex < tokens.length &&
		')' !== tokens[state.tokenIndex]) {
        if (tokenIsSyntax(tokens[state.tokenIndex]) ||
    	    tokenIsAReservedWord(tokens[state.tokenIndex])){
				state.err = new Error('Invalid function argument.');
				return;
        }
        var variableToken = tokens[state.tokenIndex];
		var variableSyntax = {};

		if ("'" === variableToken[0]) {
			if ("'" !== variableToken[variableToken.length -1]) {
				state.err = new Error('Invalid String literal');
				return;
			}
			variableSyntax.syntax = "VariableStringLiteral";
			variableSyntax.value = variableToken.substring(1, variableToken.length -1);
		// TODO number literal
		// } else if () {
		} else {
			variableSyntax.syntax = "VariableReference";
			variableSyntax.value = variableToken;
		}

        arguments.push(variableSyntax);
        state.tokenIndex++;
	}
    return arguments;
}

function tokenIsSyntax(token) {
	return -1 !== ['(', ')', '{', '}'].indexOf(token);
}

function tokenIsAReservedWord(token) {
	return -1 !== ['use', 'fn'].indexOf(token);
}