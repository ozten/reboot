module.exports = function(source, cb) {
	var state = {
		tokens: [],
		currentToken: null,
		inString: false
	};
	
	for (var i=0; i < source.length; i++) {
		switch (source[i]) {
			case "'":
			console.log("BOO ya");
			    if (state.inString) {
					state.currentToken += source[i];
					state.inString = false;
			    } else {			    	
					state.currentToken = source[i];
					state.inString = true;
			    }
				break;
			case ' ':
			case '\t':
			case '\n':
				if (state.inString) {
					state.currentToken += source[i];
				} else {
					finishToken(state);	
				}
			    break;
			case '(':
		    case ')':
			case '{':
			case '}':
				if (state.inString) {
					state.currentToken += source[i];
				} else {
					finishToken(state);
			    	// One char token
			    	state.tokens.push(source[i]);
				}
				break;
			default:
				// Start Token or continue a token
			    if (state.currentToken == null) {
			    	state.currentToken = source[i];			    
			    } else {			    	
			    	state.currentToken += source[i];
			    }
			    break;
		}
	}
	finishToken(state);
	cb(null, state.tokens);
}

function finishToken(state) {
	// End the current Token
    if (state.currentToken == null) {
    	// No OP
    } else {
    	state.tokens.push(state.currentToken);
    	state.currentToken = null;
    }
}