codeunit 50130 "AI Key Manager"
{
    // Bezpečné ukládání API klíčů přes BC Isolated Storage
    // Viz kapitola 32: Bezpečnost, GDPR a etika

    procedure StoreApiKey(ApiKey: Text)
    begin
        IsolatedStorage.Set('AzureOpenAIKey', ApiKey, DataScope::Company);
    end;

    procedure GetApiKey(): Text
    var
        ApiKey: Text;
    begin
        if not IsolatedStorage.Get('AzureOpenAIKey', DataScope::Company, ApiKey) then
            Error('API klíč není nastaven. Nastavte ho na stránce Nastavení AI kategorizace.');
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
