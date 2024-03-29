/* globals lang */
include('i18n/i18n.js');
include("pages/index.js");
Application.onStart = Application_OnStart;
Application.onUnhandledError = Application_OnError;

//pages
var homePage;
var interviewPage;

//plugins
var expertAIBrain;

/**
 * Triggered when application is started.
 * @param {EventArguments} e Returns some attributes about the specified functions
 * @this Application
 */
function Application_OnStart(e) {
    //create pages
    homePage = CreateHomePage();
	interviewPage = CreateInterviewPage();
	
	//create plugins
	expertAIBrain = new ExpertAIBrainPlugin();
	
	homePage.show();
}

function Application_OnError(e) {
	switch (e.type) {
		case "Server Error":
		case "Size Overflow":
			alert(lang.networkError);
			break;
		default:
			//change the following code for desired generic error messsage
			alert({
				title: lang.applicationError,
				message: e.message + "\n\n*" + e.sourceURL + "\n*" + e.line + "\n*" + e.stack
			});
			break;
	}
}