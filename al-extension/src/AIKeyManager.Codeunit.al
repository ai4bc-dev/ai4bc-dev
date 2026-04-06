namespace BCDemoAI;

codeunit 50130 "AI Key Manager"
{
    // Secure API key storage via BC Isolated Storage
    // See Chapter 32: Security, GDPR and Ethics

    procedure StoreApiKey(ApiKey: Text)
    begin
        IsolatedStorage.Set('AzureOpenAIKey', ApiKey, DataScope::Company);
    end;

    procedure GetApiKey(): Text
    var
        ApiKey: Text;
    begin
        if not IsolatedStorage.Get('AzureOpenAIKey', DataScope::Company, ApiKey) then
            Error('API key is not set. Configure it on the AI Categorization Setup page.');
        exit(ApiKey);
    end;

    procedure HasApiKey(): Boolean
    begin
        exit(IsolatedStorage.Contains('AzureOpenAIKey', DataScope::Company));
    end;

    procedure DeleteApiKey()
    begin
        if IsolatedStorage.Contains('AzureOpenAIKey', DataScope::Company) then
            IsolatedStorage.Delete('AzureOpenAIKey', DataScope::Company);
    end;
}
