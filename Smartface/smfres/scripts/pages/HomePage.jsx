/* globals */
var knowledgeCLPs;
var knowledgeFacts;

function CreateHomePage() {
    var page =  new SMF.UI.Page({
    name: "HomePage",
    backgroundColor: "#000000",
    onKeyPress: HomePage_onKeyPress,
    onShow: HomePage_onShow
    });
    
    page.backgroundImage = "background.png";
    var image = new SMF.UI.Image({
        width : "100%",
        left : 0,
        height : "30%",
        top : "5%",
        image : "brain.png",
        enableCache : false,
        imageFillType : SMF.UI.ImageFillType.STRETCH
    });

    var lblWelcome = new SMF.UI.Label({
        name : "lblWelcome",
    	width : '100%',
        height : '25%',
        top : '30%',
        left : '0%',
        text : "Connect to Brain Knowledge\n(Current Knowledge is not Robust)\n\nConnect to...",
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

	var btnCarsKnowledge = new SMF.UI.TextButton({
        width : '90%',
        height : '10%',
        top : '55%',
        left : '5%',
        fontColor : SMF.UI.Color.BLACK,
        pressedFontColor : "#91bfd6",
        fillColor : "#91bfd6",
        pressedFillColor : SMF.UI.Color.BLACK,
        borderWidth: 10,
        borderColor: "#91bfd6",
        multipleLine: true,
        text : "Local Cars Diagnostics Knowledge",
        onPressed : BtnCars_OnTap,
        font : new SMF.UI.Font({
            name: "Default",
            size: "10 pt",
            bold: true,
            italic: false
        }),
        roundedEdge : 10
    });

    var btnAnimalsKnowledge = new SMF.UI.TextButton({
        width : '90%',
        height : '10%',
        top : '70%',
        left : '5%',
        fontColor : SMF.UI.Color.BLACK,
        pressedFontColor : "#91bfd6",
        fillColor : "#91bfd6",
        pressedFillColor : SMF.UI.Color.BLACK,
        borderWidth: 10,
        borderColor: "#91bfd6",
        multipleLine: true,
        text : "Local Animals Expert Knowledge",
        onPressed : BtnAnimals_OnTap,
        font : new SMF.UI.Font({
            name: "Default",
            size: "10 pt",
            bold: true,
            italic: false
        }),
        roundedEdge : 10
    });


    var btnRemoteKnowledge = new SMF.UI.TextButton({
        width : '90%',
        height : '10%',
        top : '85%',
        left : '5%',
        fontColor : SMF.UI.Color.BLACK,
        pressedFontColor : "#91bfd6",
        fillColor : "#91bfd6",
        pressedFillColor : SMF.UI.Color.BLACK,
        borderWidth: 10,
        borderColor: "#91bfd6",
        multipleLine: true,
        text : "Remote Knowledge",
        onPressed : BtnRemoteKnowledge_OnTap,
        font : new SMF.UI.Font({
            name: "Default",
            size: "10 pt",
            bold: true,
            italic: false
        }),
        roundedEdge : 10
    });
        
    page.add(image);
	page.add(lblWelcome);
	page.add(btnCarsKnowledge);
	page.add(btnAnimalsKnowledge);
	page.add(btnRemoteKnowledge);
		
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
    function HomePage_onKeyPress(e) {
        if (e.keyCode === 4) {
            Application.exit();
        }
    }

    /**
     * Creates action(s) that are run when the page is appeared
     * @param {EventArguments} e Returns some attributes about the specified functions
     * @this Pages.InterviewPage
     */
    function HomePage_onShow() {
        //type your here code
        this.backgroundColor = "#000000";
        //InitializeUI();
    }


    function BtnCars_OnTap () {
        //choose brain knowledge
        knowledgeCLPs = ["auto"];
        knowledgeFacts = "auto_en";
        
        interviewPage.show();
    }

    function BtnAnimals_OnTap () {
        //choose brain knowledge
        knowledgeCLPs = ["bc","animal"];
        knowledgeFacts = "animal_en";
        
        interviewPage.show();
    }

    function BtnRemoteKnowledge_OnTap () {
        //download brain knowledge
    }

    