namespace BCDemoAI;

// Codeunit 50101 "OpenAI Setup Mgt."
// Provides configuration (endpoint URL and API key) for Azure OpenAI calls.
// Reads from AI Categorization Setup table and AI Key Manager.
// Referenced by OpenAI Helper (codeunit 50100).
codeunit 50101 "OpenAI Setup Mgt."
{
    // Returns the full endpoint URL and API key for Azure OpenAI
    procedure GetConfig(var EndpointUrl: Text; var ApiKey: Text)
    var
        AISetup: Record "AI Categorization Setup";
        KeyMgr: Codeunit "AI Key Manager";
    begin
        EndpointUrl := AISetup.GetFullEndpointUrl();
        ApiKey := KeyMgr.GetApiKey();
    end;
}
