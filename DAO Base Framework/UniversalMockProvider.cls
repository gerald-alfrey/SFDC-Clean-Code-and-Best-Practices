@isTest
public class UniversalMockProvider implements System.StubProvider {

	// Map of Method Name -> Return Value
	private Map<String, Object> returnValues = new Map<String, Object>();
	// Map of Method Name -> Exception to Throw (for negative testing)
	private Map<String, Exception> exceptions = new Map<String, Exception>();

	// 1. Configuration Method: Tell the mock what to return
	public void mockReturn(String methodName, Object returnObject) {
		returnValues.put(methodName, returnObject);
	}

	// 2. Configuration Method: Tell the mock to explode (for catch blocks)
	public void mockThrow(String methodName, Exception e) {
		exceptions.put(methodName, e);
	}

	// 3. The Required Interface Implementation
	public Object handleMethodCall(
		Object stubbedObject, 
		String stubbedMethodName, 
		Type returnType, 
		List<Type> listOfParamTypes, 
		List<String> listOfParamNames, 
		List<Object> listOfArgs
	) {
		// If we told it to throw an error, throw it
		if (exceptions.containsKey(stubbedMethodName)) {
			throw exceptions.get(stubbedMethodName);
		}

		// Return the configured value (or null if void/not configured)
		return returnValues.get(stubbedMethodName);
	}
}