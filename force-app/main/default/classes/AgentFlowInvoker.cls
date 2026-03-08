public without sharing class AgentFlowInvoker {
    
    //test Invocation Directly to agent
   @AuraEnabled(cacheable=false)
    public static Response invokeAgent(
        String agentApiName,
        String userMessage,
        String sessionId
    ) {
        Response agentResponse = new Response();

        try {
            //  Create internal Agent action
            Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse', agentApiName );

            //  Required input
            action.setInvocationParameter('userMessage', userMessage);

            //  Optional session (for memory)
            if (!String.isBlank(sessionId)) {
                action.setInvocationParameter('sessionId', sessionId);
            }

            //  Invoke agent
            List<Invocable.Action.Result> results = action.invoke();

            if (results == null || results.isEmpty()) {
                agentResponse.success = false;
                agentResponse.text = 'No response from agent';
                return agentResponse;
            }

            //  Get outputs
            Map<String, Object> outputParams =
                results[0].getOutputParameters();

            //  Parse agent response safely
            String rawResponse = (String) outputParams.get('agentResponse');

            if (String.isBlank(rawResponse)) {
                agentResponse.success = false;
                agentResponse.text = 'Empty agent response';
                return agentResponse;
            }

            Map<String, Object> agentOutput =
                (Map<String, Object>) JSON.deserializeUntyped(rawResponse);

            agentResponse.text = (String) agentOutput.get('value');
            agentResponse.sessionId = (String) outputParams.get('sessionId');
            agentResponse.success = true;

        } catch (Exception e) {
            agentResponse.success = false;
            agentResponse.text = 'Error: ' + e.getMessage();
        }

        return agentResponse;
    }

    //  Response wrapper for LWC
    public class Response {
        @AuraEnabled public String text;
        @AuraEnabled public Boolean success;
        @AuraEnabled public String sessionId;
    }
    
    /*
    @AuraEnabled
    public static String runAgent(String userText) {
        
        // Pass inputs to Flow
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('userInput', userText);
        
        // Invoke Flow
        Flow.Interview.Test_Action_to_Invoke_Agent flow =
            new Flow.Interview.Test_Action_to_Invoke_Agent(inputs);
        
        flow.start();
        
        // Get output from Flow
        System.debug('=== RUNNING USER === ' + UserInfo.getUserName());
        system.debug('=== RAW FLOW OUTPUT === ' + (String) flow.getVariableValue('agentOutput'));
        return (String) flow.getVariableValue('agentOutput');
    }
    */
    
    /*
    @AuraEnabled
    public static String invokeAgentforce(String agentApiName, String userMessage, String sessionId) {
        try {
            Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse', agentApiName);
            action.setInvocationParameter('userMessage', userMessage);
            if (String.isNotBlank(sessionId)) {
                action.setInvocationParameter('sessionId', sessionId);
            }
            // Optional: Add context like recordId
            // action.setInvocationParameter('recordId', oppId);
            
            List<Invocable.Action.Result> results = action.invoke();
            if (!results.isEmpty()) {
                Map<String, Object> outputs = results[0].getOutputParameters();
                Object responseObj = outputs.get('agentResponse');
                String agentResponse = responseObj != null ? String.valueOf(responseObj) : 'No response';
                System.debug('Agent Response: ' + agentResponse);
                return agentResponse;
            }
        } catch (Exception e) {
            System.debug('Agent invoke error: ' + e.getMessage());
            return 'Error: ' + e.getMessage();
        }
        return 'Invoke failed';
    }
        */
}