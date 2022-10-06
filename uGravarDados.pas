unit uGravarDados;

interface

type
  TDados = class
  private
    FNumeroPagina: Integer;
    FConteudo: String;
  public
    constructor Create(const ANumeroPagina: Integer;const AConteudo: string);
  published
    property NumeroPagina: Integer read FNumeroPagina write FNumeroPagina;
    property Conteudo: string read FConteudo write FConteudo;
  end;

type
  TGravarDados = class
  private
    FDados: TArray<TDados>;
    procedure LimparDados;
  public
    procedure AdicionarConteudo(const ANumeroPagina: Integer;const AConteudo: string);
    procedure Salvar(const ACaminho: String);
    procedure Carregar(const ACaminho: String);
    procedure Assigned(AGravarDados: TGravarDados);
    destructor Destroy; override;
  published
    property Dados: TArray<TDados> read FDados write FDados;
  end;

implementation

uses
  REST.Json, sysUtils, Classes;

{ TGravarDados }

procedure TGravarDados.AdicionarConteudo(const ANumeroPagina: Integer;
  const AConteudo: string);
begin
  SetLength(FDados, length(FDados) + 1);
  FDados[High(FDados)] := TDados.Create(ANumeroPagina, AConteudo);
end;

procedure TGravarDados.LimparDados;
var
  oDado: TDados;
begin
  for oDado in Self.Dados do
    oDado.Free;
  SetLength(FDados, 0);
end;

procedure TGravarDados.Assigned(AGravarDados: TGravarDados);
var
  oDado: TDados;
begin
  LimparDados;

  for oDado in AGravarDados.Dados do
    Self.AdicionarConteudo(oDado.NumeroPagina, oDado.Conteudo);
end;

procedure TGravarDados.Carregar(const ACaminho: String);
var
  ADados: TGravarDados;
  jsonString: string;
  objString: TStringList;
begin
  objString := TStringList.Create;
  try
    objString.LoadFromFile(ACaminho);
    jsonString := objString.Text.Trim;
    ADados := TJson.JsonToObject<TGravarDados>(jsonString);
    Self.Assigned(ADados);
  finally
    ADados.Free;
    objString.Free;
  end;
end;

destructor TGravarDados.Destroy;
begin
  LimparDados;
  inherited;
end;

procedure TGravarDados.Salvar(const ACaminho: String);
var
  objString: TStringList;
begin
  objString := TStringList.Create;
  try
    objString.Text := TJson.ObjectToJsonString(Self);
    objString.SaveToFile(ACaminho);
  finally
    objString.Free;
  end;
end;

{ TDados }

constructor TDados.Create(const ANumeroPagina: Integer;
  const AConteudo: string);
begin
  FNumeroPagina := ANumeroPagina;
  FConteudo := AConteudo;
end;

end.
