unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VclTee.TeeGDIPlus,
  VCLTee.TeeProcs, VCLTee.TeeDraw3D, Vcl.Grids, uQuadro, Vcl.StdCtrls, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  uGravarDados;

type
  TfmMain = class(TForm)
    pmMenu: TPopupMenu;
    Arquivo1: TMenuItem;
    Novo1: TMenuItem;
    Novo2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    SalvarComo1: TMenuItem;
    SalvarComoPDF1: TMenuItem;
    SalvarComoPDF2: TMenuItem;
    Pginas1: TMenuItem;
    Ferramentas1: TMenuItem;
    Ferramentas2: TMenuItem;
    Gravar1: TMenuItem;
    Gravar2: TMenuItem;
    Ajustedeprojeo1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Sair1: TMenuItem;
    Desfazer1: TMenuItem;
    Refazer1: TMenuItem;
    N6: TMenuItem;
    Copiar1: TMenuItem;
    Colar1: TMenuItem;
    Nova1: TMenuItem;
    Nova2: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Grande1: TMenuItem;
    CordeFundo1: TMenuItem;
    N9: TMenuItem;
    RemoverAnotaes1: TMenuItem;
    Ponterio1: TMenuItem;
    Caneta1: TMenuItem;
    Caneta2: TMenuItem;
    Borracha1: TMenuItem;
    MarcaTexto1: TMenuItem;
    exto1: TMenuItem;
    Linha1: TMenuItem;
    Eclipse1: TMenuItem;
    Retngulo1: TMenuItem;
    riangulo1: TMenuItem;
    ringuloRetangulo1: TMenuItem;
    IniciarGravaao1: TMenuItem;
    Pausar1: TMenuItem;
    Salvar1: TMenuItem;
    N10: TMenuItem;
    Ajustes1: TMenuItem;
    Ajustes2: TMenuItem;
    MostrarOcultar1: TMenuItem;
    Superior1: TMenuItem;
    Inferior1: TMenuItem;
    awBordVersoX20221: TMenuItem;
    ColorDialog1: TColorDialog;
    pnBordaCentral: TPanel;
    imgCll: TImageCollection;
    procedure FormCreate(Sender: TObject);
    procedure Ajustes1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Superior1Click(Sender: TObject);
    procedure Inferior1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure CordeFundo1Click(Sender: TObject);
    procedure ClickMenu(ASender: TObject);
    procedure pnBordaCentralMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnBordaCentralMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure SalvarComo1Click(Sender: TObject);
    procedure Novo1Click(Sender: TObject);
    procedure Novo2Click(Sender: TObject);
  private
    FPosicaoBarCentral: TPoint;
    FQuadros : TArray<TQuadro>;
    FQuadroAtivo: Integer;
    FCorPadrao: TColor;
    FUtlArqNome: string;
    procedure ProximoQuadro(const AConteudo: String = '');
    function QuadroAtivo: TQuadro;
    procedure OnProximoQuadro(ASender: TObject);
    procedure OnQuadroAnterior(ASender: TObject);
    procedure QuadroAnterior;
    procedure EsconderQuadros;
    procedure AplicarCorNosQuadros(ACor: TColor);
    procedure GravarDados(const ACaminho: string);
    procedure IniciarQuadros;
    procedure CarregarQuadros(ADados: TGravarDados);
    procedure LimparQuadros;
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  Math, fConfGravacao, fAjusteProjecao, fFechar, uCaixaDesenho, IOUtils;

{$R *.dfm}

procedure TfmMain.Inferior1Click(Sender: TObject);
begin
  TfrmAjusteProjecao.ApresentarAjuste(tajInferior, QuadroAtivo);
end;

procedure TfmMain.GravarDados(const ACaminho: string);
var
  gravarDados: TGravarDados;
  objQuadro: TQuadro;
begin
  gravarDados:= TGravarDados.Create;
  try
    for objQuadro in FQuadros do
      gravarDados.AdicionarConteudo(objQuadro.NumeroPagina, objQuadro.Conteudo);
    gravarDados.Salvar(ACaminho);
  finally
    gravarDados.Free;
  end;
end;

procedure TfmMain.N2Click(Sender: TObject);
begin
  if (Sender<>nil)and(FUtlArqNome <> '') then
  begin
    GravarDados(FUtlArqNome);
    Exit;
  end;

  with TSaveDialog.Create(Self) do
  try
    Filter := 'Arquivo data|*.data';
    if Execute(Self.Handle) then
    begin
      var extensao := TPath.GetExtension(FileName);

      if extensao = '.data' then
        extensao := ''
      else
        extensao := '.data';

      FUtlArqNome := FileName + extensao;

      GravarDados(FUtlArqNome);

      Self.Caption := FUtlArqNome;
    end;
  finally
    Free;
  end;
end;

procedure TfmMain.Novo1Click(Sender: TObject);
begin
  IniciarQuadros;
end;

procedure TfmMain.CarregarQuadros(ADados: TGravarDados);
var
  dadoQuadro: TDados;
begin
  LimparQuadros;
  for dadoQuadro in ADados.Dados do
    ProximoQuadro(dadoQuadro.Conteudo);
end;

procedure TfmMain.Novo2Click(Sender: TObject);
var
  gravarDados: TGravarDados;
  dialogOpen: TOpenDialog;
begin
  dialogOpen := TOpenDialog.Create(Self);
  try
    dialogOpen.Filter := 'Arquivo data|*.data';

    if not dialogOpen.Execute(Handle) then
      Exit;

    gravarDados:= TGravarDados.Create;
    try
      gravarDados.Carregar(dialogOpen.FileName);
      CarregarQuadros(gravarDados);
    finally
      gravarDados.Free;
    end;

  finally
    dialogOpen.Free;
  end;
end;

procedure TfmMain.LimparQuadros;
var
  quadro: TQuadro;
begin
  for quadro in FQuadros do
    quadro.Free;

  SetLength(FQuadros, 0);
  FQuadroAtivo := -1;
end;

procedure TfmMain.IniciarQuadros;
begin
  LimparQuadros;
  ProximoQuadro;
  ProximoQuadro;
end;

procedure TfmMain.pnBordaCentralMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPosicaoBarCentral.Y := Mouse.CursorPos.Y;
end;

procedure TfmMain.pnBordaCentralMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FPosicaoBarCentral.Y > Mouse.CursorPos.Y then
  begin

  end
  else
  begin

  end;
end;

function TfmMain.QuadroAtivo: TQuadro;
begin
  Result := FQuadros[FQuadroAtivo];
end;

procedure TfmMain.Sair1Click(Sender: TObject);
begin
  case TfrmFechar.ApresentarTelaFechar of
    rtsSalvarSair,
    rtsSair : Close;
  end;
end;

procedure TfmMain.SalvarComo1Click(Sender: TObject);
begin
  N2Click(nil);
end;

procedure TfmMain.Superior1Click(Sender: TObject);
begin
  TfrmAjusteProjecao.ApresentarAjuste(tajSuperior, QuadroAtivo);
end;

procedure TfmMain.Ajustes1Click(Sender: TObject);
begin
  TfmConfGravacao.ApresentarConfig;
end;

procedure TfmMain.ClickMenu(ASender: TObject);
begin
  pmMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfmMain.AplicarCorNosQuadros(ACor: TColor);
var
  quadro: TQuadro;
begin
  for quadro in FQuadros do
    quadro.CorDoQuadro := ACor;
end;

procedure TfmMain.CordeFundo1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    AplicarCorNosQuadros(ColorDialog1.Color);
    FCorPadrao := ColorDialog1.Color;
  end;
end;

procedure TfmMain.ProximoQuadro(const AConteudo: String);
var
  objQuadro: TQuadro;
begin
  Inc(FQuadroAtivo);

  if FQuadroAtivo > (Length(FQuadros)-1) then
  begin
    objQuadro := TQuadro.Create(Self);
    objQuadro.Parent := Self;
    objQuadro.OnCliqueMenu := ClickMenu;
    objQuadro.ImagemBorda.Assign(imgCll.GetBitmap('Bordas', 35, 23));
    objQuadro.ImagemLogo.Assign(imgCll.GetBitmap('catman', 24, 21));
    objQuadro.ImagemMenu.Assign(imgCll.GetBitmap('menu', 24, 24));
    objQuadro.Width := (Self.Width - 14) div 2;
    objQuadro.Height := Self.Height - 30;
    objQuadro.Visible := True;
    objQuadro.AutoSize := False;
    objQuadro.Transparent := False;
    objQuadro.NumeroPagina := FQuadroAtivo;
    objQuadro.Stretch := True;
    objQuadro.OnEventoProximo := OnProximoQuadro;
    objQuadro.OnEventoAnterior := OnQuadroAnterior;
    objQuadro.CorDoQuadro := FCorPadrao;
    objQuadro.Conteudo := AConteudo;
    SetLength(FQuadros, FQuadroAtivo + 1);
    FQuadros[FQuadroAtivo]  := objQuadro;
  end;

  if FQuadroAtivo = 0 then
  begin
    FQuadros[FQuadroAtivo].Visible := True;
    FQuadros[FQuadroAtivo].Left := 0;
    FQuadros[FQuadroAtivo].Top  := 0;
  end;

  if FQuadroAtivo = 1 then
  begin
    FQuadros[FQuadroAtivo].Visible := True;
    FQuadros[FQuadroAtivo].Left := 478 + 14;
    FQuadros[FQuadroAtivo].Top  := 0;
  end;

  if FQuadroAtivo > 1 then
  begin
    FQuadros[FQuadroAtivo-2].Visible := False;
    FQuadros[FQuadroAtivo-1].Visible := True;
    FQuadros[FQuadroAtivo-1].Left := 0;
    FQuadros[FQuadroAtivo-1].Top := 0;
    FQuadros[FQuadroAtivo].Visible := True;
    FQuadros[FQuadroAtivo].Left := 478 + 14;
    FQuadros[FQuadroAtivo].Top := 0;
  end;
end;

procedure TfmMain.QuadroAnterior;
begin
  EsconderQuadros;

  Dec(FQuadroAtivo);

  if FQuadroAtivo = -1 then
    FQuadroAtivo := 0;

  FQuadros[FQuadroAtivo].Visible := True;
  FQuadros[FQuadroAtivo].Left := 0;
  FQuadros[FQuadroAtivo].Top := 0;
  FQuadros[FQuadroAtivo+1].Visible := True;
  FQuadros[FQuadroAtivo+1].Left := 478 + 14;
  FQuadros[FQuadroAtivo+1].Top := 0;
end;

procedure TfmMain.EsconderQuadros;
var
  quadro : TQuadro;
begin
  for quadro in FQuadros do
    quadro.Visible := False;
end;

procedure TfmMain.OnProximoQuadro(ASender: TObject);
begin
  ProximoQuadro;
end;

procedure TfmMain.OnQuadroAnterior(ASender: TObject);
begin
  QuadroAnterior;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TfrmCaixaDesenho.ApresentarCaixa(Self);
  FCorPadrao := clNone;
  FUtlArqNome := '';
  Self.Caption := '';
  IniciarQuadros;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
  begin
    if TfrmAjusteProjecao.IsActive then
      TfrmAjusteProjecao.FecharTela
    else
      Close;
  end;
end;

end.

