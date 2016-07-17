/* globals */

var lblQuestion;
var btnAnswer1;
var btnAnswer2;
var btnAnswer3;
var btnPrevious;
var btnNext;

var answerIndex = 0;

function CreateInterviewPage() {
    	var page =  new SMF.UI.Page({
        name: "InterviewPage",
        onKeyPress: InterviewPage_onKeyPress,
        onShow: InterviewPage_onShow
    });

    page.backgroundImage = "background.png";

    lblQuestion = new SMF.UI.Label({
            name : "lblQuestion",
    		width : '100%',
            height : '25%',
            top : '10%',
            left : '0%',
            text : "Hello",
            fontColor : "#91bfd6",
            multipleLine: true,
            textAlignment : SMF.UI.TextAlignment.CENTER,
            font : new SMF.UI.Font({
                name: "Default",
                size: "12 pt",
                bold: true,
            italic: false
            })
        });

		//answers buttons can't be hardcoded to yes button and no button
		//answers buttons must be fetched from the AI Brain knowledge because some questions might have other answers other than yes and no answers
		btnAnswer1 = new SMF.UI.TextButton({
            width : '60%',
            height : '10%',
            top : '35%',
            left : '20%',
            fontColor : SMF.UI.Color.BLACK,
            pressedFontColor : "#91bfd6",
            fillColor : "#91bfd6",
            pressedFillColor : SMF.UI.Color.BLACK,
            text : "Yes",
            onPressed : BtnAnswer1_OnTap,
            font : new SMF.UI.Font({
                name: "Default",
                size: "10 pt",
                bold: true,
                italic: false
            }),
            roundedEdge : 10
        });
        
        btnAnswer2 = new SMF.UI.TextButton({
            width : '60%',
            height : '10%',
            top : '45%',
            left : '20%',
            fontColor : SMF.UI.Color.BLACK,
            pressedFontColor : "#91bfd6",
            fillColor : "#91bfd6",
            pressedFillColor : SMF.UI.Color.BLACK,
            text : "No",
            onPressed : BtnAnswer2_OnTap,
            font : new SMF.UI.Font({
                name: "Default",
                size: "10 pt",
                bold: true,
                italic: false
            }),
            roundedEdge : 10
        });

        btnAnswer3 = new SMF.UI.TextButton({
            width : '60%',
            height : '10%',
            top : '55%',
            left : '20%',
            fontColor : SMF.UI.Color.BLACK,
            pressedFontColor : "#91bfd6",
            fillColor : "#91bfd6",
            pressedFillColor : SMF.UI.Color.BLACK,
            text : "No",
            onPressed : BtnAnswer3_OnTap,
            font : new SMF.UI.Font({
                name: "Default",
                size: "10 pt",
                bold: true,
                italic: false
            }),
            roundedEdge : 10
        });

        btnPrevious = new SMF.UI.TextButton({
            width : '30%',
            height : '20%',
            top : '85%',
            left : '10%',
fontColor : SMF.UI.Color.BLACK,
pressedFontColor : "#91bfd6",
fillColor : "#91bfd6",
pressedFillColor : SMF.UI.Color.BLACK,
            text : "Previous",
            onPressed : BtnPrevious_OnTap,
font : new SMF.UI.Font({
name: "Default",
size: "10 pt",
bold: true,
italic: false
}),
roundedEdge : 10
        });
        
        btnNext = new SMF.UI.TextButton({
            width : '30%',
            height : '20%',
            top : '85%',
            left : '60%',
fontColor : SMF.UI.Color.BLACK,
pressedFontColor : "#91bfd6",
fillColor : "#91bfd6",
pressedFillColor : SMF.UI.Color.BLACK,
            text : "Next",
            onPressed : BtnNext_OnTap,
font : new SMF.UI.Font({
name: "Default",
size: "10 pt",
bold: true,
italic: false
}),
roundedEdge : 10
        });
		
		page.add(lblQuestion);
		page.add(btnAnswer1);
		page.add(btnAnswer2);
		page.add(btnAnswer3);
		page.add(btnPrevious);
		page.add(btnNext);
		
		return page;
}
	
	/**
     * Intializes and adds the subviews of the current page
     *
     */
    function InitializeUI() {
    	
    }

    /**
     * Creates action(s) that are run when the user press the key of the devices.
     * @param {KeyCodeEventArguments} e Uses to for key code argument. It returns e.keyCode parameter.
     * @this Pages.InterviewPage
     */
    function InterviewPage_onKeyPress(e) {
        if (e.keyCode === 4) {
            Application.exit();
        }
    }

    /**
     * Creates action(s) that are run when the page is appeared
     * @param {EventArguments} e Returns some attributes about the specified functions
     * @this Pages.InterviewPage
     */
    function InterviewPage_onShow() {
        //type your here code
        
        //InitializeUI();
expertAIBrain.setPreviousButtonHidden = function(e) {

if (e=="Yes")
btnPrevious.text = "Home";
else
btnPrevious.text = "Previous";
};

expertAIBrain.setNextButtonHidden = function(e) {

if (e=="Yes")
btnNext.alpha = "0%";
else
btnNext.alpha = "100%";
};

expertAIBrain.setAnswerViewHidden = function(e) {
if (e=="Yes") {
btnAnswer1.alpha = "0%";
btnAnswer2.alpha = "0%";
btnAnswer3.alpha = "0%";
}
else {
btnAnswer1.alpha = "100%";
btnAnswer2.alpha = "100%";
btnAnswer3.alpha = "100%";
}
};

expertAIBrain.setDisplay = function(e) {
//alert(e);
lblQuestion.text = e;
};

expertAIBrain.setNextButtonTitle = function(e) {
btnNext.text = e;
};

expertAIBrain.reloadAnswers = function(e) {

btnAnswer1.text = expertAIBrain.getAnswerAtIndex(0);
btnAnswer2.text = expertAIBrain.getAnswerAtIndex(1);

if (expertAIBrain.getNumberOfAnswers() == 2) {
btnAnswer3.alpha = "0%";
}
else {
btnAnswer3.alpha = "100%";
btnAnswer3.text = expertAIBrain.getAnswerAtIndex(2);
}

};

expertAIBrain.feedBrainWithKnowledgeCLPsLocationsAndFactsLocation(knowledgeCLPs,knowledgeFacts);
expertAIBrain.initialize();

BtnAnswer1_OnTap();

    }

function EnableButton(button) {
button.fontColor = SMF.UI.Color.BLACK;
button.pressedFontColor = "#91bfd6";
button.fillColor = "#91bfd6";
button.pressedFillColor = SMF.UI.Color.BLACK;
}

function DisableButton(button) {
button.fontColor = "#91bfd6";
button.pressedFontColor = SMF.UI.Color.BLACK;
button.fillColor = SMF.UI.Color.BLACK;
button.pressedFillColor = "#91bfd6";
}
    
    function BtnAnswer1_OnTap () {
answerIndex = 0;

EnableButton(btnAnswer1);
DisableButton(btnAnswer2);
DisableButton(btnAnswer3);
    	
    }
    
    function BtnAnswer2_OnTap () {
answerIndex = 1;

DisableButton(btnAnswer1);
EnableButton(btnAnswer2);
DisableButton(btnAnswer3);
    	
    }

function BtnAnswer3_OnTap () {
answerIndex = 2;

DisableButton(btnAnswer1);
DisableButton(btnAnswer2);
EnableButton(btnAnswer3);

}

    function BtnPrevious_OnTap () {
        if (btnPrevious.text == "Home") {
            Pages.back();
        }
        else {
            expertAIBrain.goPrevious();
        }
    }
    
    function BtnNext_OnTap () {
        expertAIBrain.goNextWithAnswerAtIndex(answerIndex);
    }