public class RuleEvaluator {
    static String logicalExpression;
    static Map<String, Boolean> valueMap;


    /****
	 * 
	 */
    public RuleEvaluator(String booleanFormula, Map<String, Boolean> booleanValueByNameMap) {   
        logicalExpression = booleanFormula;
        valueMap = booleanValueByNameMap;
    }

    /****
	 * 
	 */
    public EvaluationResult evaluate() {
        EvaluationResult er = new EvaluationResult();
        Expression result;
        
        try {
            logicalExpression = logicalExpression.remove(' ').toUpperCase().trim();

            if (String.isBlank(logicalExpression) || valueMap == null || !RuleEvaluator.checkStringFormat(logicalExpression)) {
                er.isError = true;
                er.result = null;
                er.errorMessage = 'Evaluation formula or valueMap or both are invalid. \n Evaluation Formula: '+ logicalExpression + '\n valueMap: '+ valueMap;
            } else {
                result = new Evaluator().evaluate(logicalExpression, true, null);
                system.debug('result: '+result);
                system.debug('result: '+result.evaluate());

                er.isError = false;
                er.result = result.evaluate();

            }
        
        } catch (Exception e) {
            er.isError = true;
            er.result = null;
            er.errorMessage = e.getMessage();
        }
        system.debug('er: '+er);
        return er;
    }
    
	/****
	 * 
	 */
    static Boolean checkStringFormat(String formula) {
        if(string.isBlank(formula)) return false;
        
        formula = formula.remove(' ').toUpperCase().trim();

        Integer bracesCount = 0;
        Boolean positiveBraceCount = false;
        
        for (Integer i = 1; i <= formula.length(); i++ ) {
            String s = formula.substring(i-1,i);
            if (s == ')') {
                bracesCount--;
                if (bracesCount < 0) return false;
            } else if (s == '(') {
                bracesCount++;
                positiveBraceCount = true;
                if (!(formula.substring(i-3,i-1) == 'OR'|| formula.substring(i-4,i-1) == 'NOT' || formula.substring(i-4,i-1) == 'AND')) {
                    return false;
                }
            }
        }
        return bracesCount == 0 && positiveBraceCount;
    }
    
    /****
	 * 
	 */
    static Integer findEndIndex(String formula) {
        integer bracesCount = 0;
        for (Integer i = 1; i <= formula.length(); i++ ) {
            if (formula.substring(i-1,i) == '(') {
                bracesCount++;
            } else if (formula.substring(i-1,i) == ')') {
                bracesCount--;
                if (bracesCount == 0) return i-1;
            }
        }
        
        return -1;
    }
	
    /****
	 * 
	 *
    static void braceCount(String formula) {
        integer bracesCount = -1;
        for (integer i = 1; i <= formula.length(); i++ ) {
            if (formula.substring(i-1,i)=='(') {
                bracesCount++;
            } else if (formula.substring(i-1,i)==')') {
                bracesCount--;
            }
            
        }
    }
	*/
    
    /****
	 * 
	 */
    public class EvaluationResult {
        Boolean isError;
        Boolean result;
        String errorMessage;

        public Boolean isError () {
            return this.isError;
        }

        public Boolean getResult () {
            return this.result;
        }

        public String getErrorMessage () {
            return this.errorMessage;
        }
    }


    private class Evaluator extends ElementsUtility {

        /****
         * 
         */
        private Expression evaluate(String formula, Boolean isTopLevel, String prevExp) {
            system.debug('Formula: '+formula);
            Expression expr;
            
            if (isTopLevel) {
                if (formula.startsWith('AND')) {
                    expr = new Evaluator().evaluate(formula.substring(4,formula.length()-1), false, 'AND');
                } else if (formula.startsWith('OR')) {
                    expr = new Evaluator().evaluate(formula.substring(3,formula.length()-1), false, 'OR');
                }
            } else {
                List<String> elements = splitElements(formula);
                system.debug('Evaluating elements: '+elements);

                if (prevExp == 'AND') {
                    expr = new AndComposite();
                } else if (prevExp == 'OR'){
                    expr = new OrComposite();
                }

                for (String s : elements) {
                    system.debug('this Element: '+s);
                    if (s.startsWith('AND')) {
                        expr.add(new Evaluator().evaluate(s.substring(4,s.length()-1), false, 'AND'));
                        system.debug('expr AND: '+expr);
                    } else if (s.startsWith('OR')) {
                        expr.add(new Evaluator().evaluate(s.substring(3,s.length()-1), false, 'OR'));
                        system.debug('expr OR: '+expr);
                    } else {
                        for (String e : s.split(',')) {
                        	expr.add(new Variable(e).set(e,valueMap.get(e)));
                        }
                        system.debug('expr after: '+expr);
                    }
                }
            }
            
            return expr;
        }
    }

    private virtual class ElementsUtility {
        List<String> elements = new List<String>();

        /****
         * 
         */
        private List<String> splitElements(String formula) {
            system.debug('String to check: '+formula);
            if (formula.startsWith('AND') || formula.startsWith('OR')) {
                Integer endIndex = RuleEvaluator.findEndIndex(formula);
                String newElement;
                newElement = formula.substring(0,endIndex+1);
                system.debug('newElement: '+newElement);
                elements.add(newElement);
                if (!String.isBlank(formula.substring(endIndex+1))) this.splitElements(formula.substring(endIndex+2));
                
            } else {
                String newElement = formula.substringBefore(',');
                system.debug('newElement: '+newElement);
                elements.add(newElement);
                if (!String.isBlank(formula.substringAfter(','))) this.splitElements(formula.substringAfter(','));
            }

            return elements;
        }
    }
}