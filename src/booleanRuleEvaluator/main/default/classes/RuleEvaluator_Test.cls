@isTest
private class RuleEvaluator_Test {
    
    static Map<String, Boolean> getValueMap() {
        Map<String, Boolean> valueMap = new map<string,boolean>{
                '1'=>false,
                '2'=>true,
                '3'=>false,
                '4'=>true,
                '5'=>true,
                '6'=>true,
                '7'=>false,
                '8'=>false,
                '9'=>false,
                '10'=>true,
                '11'=>true,
                '12'=>true
            };
        
        return valueMap;
    }
    
    @isTest
    static void testSuccessfulEvaluation() {
        Map<String, Boolean> valueMap = getValueMap();
        
        // complex logic 1
        String s = 'AND(OR(AND(9,10,11),7,8),5,OR(4,AND(1,2,3)),6)';
        RuleEvaluator.EvaluationResult evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(false, evalResult.getResult(), 'Incorrect Evaluation');
        
        // Complex logic 2
        s = 'OR(1,AND(2, 3),4,  OR (AND (5,1),6 ))';
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(true, evalResult.getResult(), 'Incorrect Evaluation');
        
        // Single element
        s = 'AND(1)';
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(false, evalResult.getResult(), 'Incorrect Evaluation');
        
        // Simple AND evaluating to false
        s = 'AND(1,2,3)';
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(false, evalResult.getResult(), 'Incorrect Evaluation');
        
        // Simple AND evaluating to true
        s = 'AND(2,4,6)';
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(true, evalResult.getResult(), 'Incorrect Evaluation');
        
        // Simple OR evaluating to true. Also with spaces in the string.
        s = 'OR (7,   8, 9)  ';
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(false, evalResult.isError(), 'Error should not occur');
        system.assertEquals(evalResult.getResult(), false, 'Incorrect Evaluation');
    }
    
    @isTest
    static void testNullInput() {
        Map<String, Boolean> valueMap = getValueMap();
        
        // Blank logic
        String s = '';
        RuleEvaluator.EvaluationResult evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(true, evalResult.isError(), 'Error should be thrown');
        system.assertEquals(null, evalResult.getResult(), 'Incorrect Evaluation');
        system.assert(evalResult.getErrorMessage().contains('Evaluation formula or valueMap'), 'Incorrect ErrorMessage');
        
        // Blank map
        s = 'AND(1)';
        valueMap = null;
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(true, evalResult.isError(), 'Error should be thrown');
        system.assertEquals(null, evalResult.getResult(), 'Incorrect Evaluation');
        system.assert(evalResult.getErrorMessage().contains('Evaluation formula or valueMap'), 'Incorrect ErrorMessage');
        
        // Blank logic and map
        s = '';
        valueMap = null;
        evalResult = new RuleEvaluator(s,valueMap).evaluate();
        system.assertEquals(true, evalResult.isError(), 'Error should be thrown');
        system.assertEquals(null, evalResult.getResult(), 'Incorrect Evaluation');
        system.assert(evalResult.getErrorMessage().contains('Evaluation formula or valueMap'), 'Incorrect ErrorMessage');
    }
}