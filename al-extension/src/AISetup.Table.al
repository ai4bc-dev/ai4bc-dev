table 50101 "AI Categorization Setup"
{
    Caption = 'Nastavení AI kategorizace';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primární klíč';
            DataClassification = SystemMetadata;
        }
        field(10; "Endpoint URL"; Text[250])
        {
            Caption = 'Azure OpenAI Endpoint URL';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if ("Endpoint URL" <> '') and (not "Endpoint URL".StartsWith('https://')) then
                    Error('Endpoint URL musí začínat https://');
            end;
        }
        field(20; "Deployment Name"; Text[100])
        {
            Caption = 'Název deployment modelu';
            DataClassification = SystemMetadata;
        }
        field(30; "API Version"; Text[50])
        {
            Caption = 'Verze API';
            DataClassification = SystemMetadata;
            InitValue = '2025-01-01-preview';
        }
        field(40; "Max Tokens"; Integer)
        {
            Caption = 'Maximální počet tokenů odpovědi';
            DataClassification = SystemMetadata;
            InitValue = 100;
            MinValue = 10;
            MaxValue = 4000;
        }
        field(50; "Temperature"; Decimal)
        {
            Caption = 'Temperature (0.0–2.0)';
            DataClassification = SystemMetadata;
            InitValue = 0.1;
            MinValue = 0;
            MaxValue = 2;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;

    procedure GetFullEndpointUrl(): Text
    begin
        GetSetup();
        TestField("Endpoint URL");
        TestField("Deployment Name");
        exit("Endpoint URL" + '/openai/deployments/' + "Deployment Name" +
             '/chat/completions?api-version=' + "API Version");
    end;
}
