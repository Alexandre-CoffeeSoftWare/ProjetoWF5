unit uQuadro;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, uObjetoImage,
  Windows, vcl.Graphics, Messages;

type
  TQuadro = class(TImage)
  private
    FObjetoQuadro: TObjetoImage;
    FCorDoQuadro: TColor;
    FBordaHorizonta: TBitmap;
    FBordaVertical: TBitmap;
    FnrosFigurasLargura: Integer;
    FnrosFigurasAltura: Integer;
    FObjMenu: TObjetoImage;
    FOnCliqueMenu: TNotifyEvent;
    FAtualizar: Boolean;
    FObjetoLogo: TObjetoImage;
    FNumeroPaginaPosicao: TPoint;
    FNumeroPagina: Integer;
    FScrollVerticalConteudo: Integer;
    FOnEventoProximo: TNotifyEvent;
    FPosicaoMouseX: Integer;
    FOnEventoAnterior: TNotifyEvent;
    FConteudoPagina: string;
    procedure DesenharQuadroNaTela;
    procedure SetCorDoQuadro(const Value: TColor);
    procedure ConfigurarPadraoQuadro;
    procedure CalcularQuadro;
    procedure DesenharQuadro;
    procedure CalcularBorda;
    procedure DesenharBordaNoQuadro;
    procedure SetBorda(const Value: TBitmap);
    procedure CalcularMenu;
    procedure SetImagemMenu(const Value: TBitmap);
    procedure DesenharMenuNoQuadro;
    procedure WmMouseDown(var AwmMouseDow: TWMLButtonDown);message WM_LBUTTONDOWN;
    procedure WmMouseMove(var AwmMouseMove: TWMMouseMove);message WM_MOUSEMOVE;
    procedure WmMouseUp(var AwmMouseUp: TWMLButtonUp);message WM_LBUTTONUP;
    function GetImageMenu: TBitmap;
    procedure CalcularEDesenharObjetos;
    function ValidarRecalculo: Boolean;
    function GetImageLogoSuperior: TBitmap;
    procedure SetImageLogoSuperior(const Value: TBitmap);
    procedure CalcularImagemLogo;
    procedure DesenharLogoNaBorda;
    procedure SetNumeroPagina(const Value: integer);
    procedure CalcularNumeroPagina;
    procedure DesenharNumeroPagina;
    function MouseAreaUtil(const X: Integer;Const Y: Integer): Boolean;
    procedure AmazenarConteudo(const PosX, PosY: Integer);
    procedure SetConteudoPagina(const Value: string);
  protected
    procedure Paint;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property CorDoQuadro : TColor read FCorDoQuadro write SetCorDoQuadro;
    property ImagemBorda : TBitmap read FBordaHorizonta write SetBorda;
    property ImagemMenu  : TBitmap read GetImageMenu write SetImagemMenu;
    property OnCliqueMenu : TNotifyEvent read FOnCliqueMenu write FOnCliqueMenu;
    property ImagemLogo : TBitmap read GetImageLogoSuperior write SetImageLogoSuperior;
    property NumeroPagina : integer read FNumeroPagina write SetNumeroPagina;
    property OnEventoProximo : TNotifyEvent read FOnEventoProximo write FOnEventoProximo;
    property OnEventoAnterior : TNotifyEvent read FOnEventoAnterior write FOnEventoAnterior;
    property Conteudo: string read FConteudoPagina write SetConteudoPagina;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
begin
  RegisterComponents('CompTeste', [TQuadro]);
end;

procedure TQuadro.CalcularBorda;
var
  larguraQuadro: Integer;
  AlturaQuadro: Integer;
  larguraBorda: Integer;
  AlturaBorda: Integer;
begin
  TObjetoImage.RetocionarImagem90G(FBordaHorizonta, FBordaVertical);
  larguraQuadro := FObjetoQuadro.Image.Width;
  AlturaQuadro := FObjetoQuadro.Image.Height;
  larguraBorda := FBordaHorizonta.Width;
  AlturaBorda := FBordaVertical.Height;

  if (AlturaBorda = 0)or(larguraBorda = 0) then
  begin
    FnrosFigurasLargura := 0;
    FnrosFigurasAltura := 0;
    Exit;
  end;

  FnrosFigurasLargura := (larguraQuadro div larguraBorda);
  FnrosFigurasAltura := (AlturaQuadro div AlturaBorda);
end;

procedure TQuadro.CalcularMenu;
begin
  if (FObjMenu.Image.Width = 0) or (FObjMenu.Image.Width = 0) then
    Exit;

  FObjMenu.Left := Trunc(FObjetoQuadro.Image.Width * 0.03);
  FObjMenu.Top := FObjetoQuadro.Image.Height - FObjMenu.Image.Height;
end;

procedure TQuadro.CalcularNumeroPagina;
begin
  FNumeroPaginaPosicao.X := FObjetoQuadro.Image.Width - FBordaHorizonta.Height;;
  FNumeroPaginaPosicao.Y := FObjetoQuadro.Image.Height - FBordaVertical.Height + 10;
end;

procedure TQuadro.ConfigurarPadraoQuadro;
begin
  FObjetoQuadro.Left := 1;
  FObjetoQuadro.Left := 1;
  CalcularQuadro;
  SetCorDoQuadro($2A4930);
end;

constructor TQuadro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjetoQuadro := TObjetoImage.Create;
  ConfigurarPadraoQuadro;
  FBordaHorizonta := TBitmap.Create;
  FBordaVertical := TBitmap.Create;
  FObjMenu := TObjetoImage.Create;
  FAtualizar := True;
  FObjetoLogo := TObjetoImage.Create;
  FScrollVerticalConteudo := 0;
  FPosicaoMouseX := 0;
  FConteudoPagina := '';
end;

destructor TQuadro.Destroy;
begin
  FObjetoQuadro.Free;
  FBordaHorizonta.Free;
  FBordaVertical.Free;
  FObjMenu.Free;
  FObjetoLogo.Free;
  inherited;
end;

function TQuadro.GetImageLogoSuperior: TBitmap;
begin
  Result := FObjetoLogo.Image;
end;

function TQuadro.GetImageMenu: TBitmap;
begin
  Result := FObjMenu.Image;
end;

procedure TQuadro.DesenharBordaNoQuadro;
var
  posicaoHorizontal: Integer;
  larguraBorda: Integer;
  alturaBordaH: Integer;
  alturaBordaV: Integer;
  posicaoVertical: Integer;
  escalaDoQuadro: Integer;
begin
  if (FnrosFigurasLargura=0)or(FnrosFigurasAltura=0) then
    Exit;

  larguraBorda := FBordaHorizonta.Width;
  alturaBordaH := FBordaHorizonta.Height;
  alturaBordaV := FBordaVertical.Height;

  for escalaDoQuadro := 1 to 2 do
  begin
    {Posição vertical Direto e esquerdo}
    for var nroQuadroAltura:= 0 to FnrosFigurasAltura do
    begin
      posicaoHorizontal := IfThen(escalaDoQuadro = 2, FObjetoQuadro.Image.Width - FBordaVertical.Width, 0) - 1;
      posicaoVertical := (nroQuadroAltura * alturaBordaV) + alturaBordaH;
      BitBlt(FObjetoQuadro.Image.Canvas.Handle, posicaoHorizontal, posicaoVertical, FBordaVertical.Width, FBordaVertical.Height, FBordaVertical.Canvas.Handle, 0, 0, SRCCOPY);
    end;
    {Posição horizontal superior e inferior}
    for var nroQuadroLargura:= 0 to FnrosFigurasLargura do
    begin
      posicaoHorizontal := nroQuadroLargura * larguraBorda;
      posicaoVertical := IfThen(escalaDoQuadro = 2, FObjetoQuadro.Image.Height - FBordaHorizonta.Height, 0);
      BitBlt(FObjetoQuadro.Image.Canvas.Handle, posicaoHorizontal, posicaoVertical, FBordaHorizonta.Width, FBordaHorizonta.Height, FBordaHorizonta.Canvas.Handle, 0, 0, SRCCOPY);
    end;
  end;
end;

procedure TQuadro.DesenharQuadro;
begin
  if not FObjetoQuadro.Visivel then
    Exit;

  FObjetoQuadro.Image.Canvas.Lock;
  try
    FObjetoQuadro.Image.Canvas.Pen.Style := psClear;
    FObjetoQuadro.Image.Canvas.Brush.Style := bsSolid;
    FObjetoQuadro.Image.Canvas.Brush.Color := FCorDoQuadro;
    FObjetoQuadro.Image.Canvas.Rectangle(FObjetoQuadro.Left, FObjetoQuadro.Top, FObjetoQuadro.Image.Width, FObjetoQuadro.Image.Height);
  finally
    FObjetoQuadro.Image.Canvas.Unlock;
  end;
end;

procedure TQuadro.DesenharLogoNaBorda;
begin
  if FObjetoLogo.Visivel then
    BitBlt(FObjetoQuadro.Image.Canvas.Handle, FObjetoLogo.Left, FObjetoLogo.Top,
      FObjetoLogo.Image.Width, FObjetoLogo.Image.Height, FObjetoLogo.Image.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TQuadro.DesenharMenuNoQuadro;
begin
  if FObjMenu.Visivel then
    BitBlt(FObjetoQuadro.Image.Canvas.Handle, FObjMenu.Left, FObjMenu.Top, FObjMenu.Image.Width, FObjMenu.Image.Height, FObjMenu.Image.Canvas.Handle, 0, 0, SRCAND);
end;

procedure TQuadro.DesenharQuadroNaTela;
begin
  Self.Picture.Bitmap.Assign(FObjetoQuadro.Image);
end;

procedure TQuadro.DesenharNumeroPagina;
begin
  FObjetoQuadro.Image.Canvas.Font.Size := 15;
  FObjetoQuadro.Image.Canvas.Font.Color := clSilver;
  FObjetoQuadro.Image.Canvas.Brush.Style := bsClear;
  FObjetoQuadro.Image.Canvas.TextOut(FNumeroPaginaPosicao.X, FNumeroPaginaPosicao.Y, FNumeroPagina.ToString);
end;

procedure TQuadro.CalcularEDesenharObjetos;
begin
  CalcularQuadro;
  CalcularBorda;
  CalcularMenu;
  CalcularImagemLogo;
  CalcularNumeroPagina;
  DesenharQuadro;
  DesenharBordaNoQuadro;
  DesenharMenuNoQuadro;
  DesenharLogoNaBorda;
  DesenharNumeroPagina;
end;

function TQuadro.ValidarRecalculo: Boolean;
begin
  Result := FAtualizar or
    ((Self.Width-1) <> FObjetoQuadro.Image.Width) or
    ((Self.Height-1) <> FObjetoQuadro.Image.Height);

  FAtualizar := False;
end;

procedure TQuadro.Paint;
begin
  if ValidarRecalculo then
  begin
    CalcularEDesenharObjetos;
    DesenharQuadroNaTela;
  end;
  inherited;
end;

procedure TQuadro.CalcularQuadro;
begin
  FObjetoQuadro.Left := 1;
  FObjetoQuadro.Top := 1;
  FObjetoQuadro.Image.Width := Self.Width - 1;
  FObjetoQuadro.Image.Height := Self.Height - 1;
end;

procedure TQuadro.SetBorda(const Value: TBitmap);
begin
  FBordaHorizonta.Assign(Value);
  FAtualizar := True;
  Repaint;
end;

procedure TQuadro.SetConteudoPagina(const Value: string);
var
  ponto: string;
  pontoX: string;
  pontoY: string;
  iniciar: Boolean;
begin
  FConteudoPagina := Value;
  iniciar := False;
  for ponto in Value.Split([',']) do
  begin
    if ponto.Trim = '' then
      Continue;
    pontoX := ponto.Split(['.'])[0];
    pontoY := ponto.Split(['.'])[1];
    if not iniciar then
      Self.Canvas.MoveTo(pontoX.ToInteger, pontoY.ToInteger);
    iniciar := True;
    Self.Canvas.LineTo(pontoX.ToInteger, pontoY.ToInteger);
  end;
end;

procedure TQuadro.SetCorDoQuadro(const Value: TColor);
begin
  if Value = clNone then
    Exit;
  FCorDoQuadro := Value;
  FAtualizar := True;
  Repaint;
end;

procedure TQuadro.SetImageLogoSuperior(const Value: TBitmap);
begin
  FObjetoLogo.Image.Assign(Value);
  FAtualizar := True;
  Repaint;
end;

procedure TQuadro.SetImagemMenu(const Value: TBitmap);
begin
  if (Value.Width = 0) or (Value.Height = 0) then
    Exit;
  FObjMenu.Image.Assign(Value);
  FAtualizar := True;
  Repaint;
end;

procedure TQuadro.SetNumeroPagina(const Value: integer);
begin
  FNumeroPagina := Value;
  FAtualizar := True;
  Repaint;
end;

procedure TQuadro.AmazenarConteudo(const PosX: Integer;const PosY: Integer);
begin
  FConteudoPagina := FConteudoPagina + PosX.ToString + '.' + posY.ToString + ',';
end;

function TQuadro.MouseAreaUtil(const X: Integer;Const Y: Integer): Boolean;
var
  leftColisao: Integer;
  topColisao: Integer;
  widthQuadro: integer;
  heightQuadro: Integer;
begin
  leftColisao := FBordaVertical.Width;
  topColisao := FBordaHorizonta.Height;
  widthQuadro := Trunc(FObjetoQuadro.Image.Width - leftColisao);
  heightQuadro := Trunc(FObjetoQuadro.Image.Height - (topColisao * 2));

  Result := (X > leftColisao) and
            (X < widthQuadro) and
            (Y > topColisao) and
            (Y < heightQuadro) and
            (GetKeyState(VK_LBUTTON)<0);
end;

procedure TQuadro.WmMouseDown(var AwmMouseDow: TWMLButtonDown);
var
  pontoColisao: Boolean;
begin
  inherited;
  Self.Canvas.MoveTo(AwmMouseDow.XPos, AwmMouseDow.YPos);

  pontoColisao := (AwmMouseDow.XPos >= FObjMenu.Left) and
                  (AwmMouseDow.XPos <= FObjMenu.Left + FObjMenu.Image.Width) and
                  (AwmMouseDow.YPos >= FObjMenu.Top) and
                  (AwmMouseDow.YPos <= FObjMenu.Top + FObjMenu.Image.Height);

  if (AwmMouseDow.YPos >= FObjMenu.Top) then
    FPosicaoMouseX := AwmMouseDow.XPos
  else
    FPosicaoMouseX := 0;

  if pontoColisao and Assigned(FOnCliqueMenu) then
    FOnCliqueMenu(Self);
end;

procedure TQuadro.WmMouseMove(var AwmMouseMove: TWMMouseMove);
begin
  inherited;
  if MouseAreaUtil(AwmMouseMove.XPos, AwmMouseMove.YPos) then
  begin
    Self.Canvas.LineTo(AwmMouseMove.XPos, AwmMouseMove.YPos);
    AmazenarConteudo(AwmMouseMove.XPos, AwmMouseMove.YPos);
  end;
end;

procedure TQuadro.WmMouseUp(var AwmMouseUp: TWMLButtonUp);
begin
  inherited;
  if (AwmMouseUp.YPos >= FObjMenu.Top) then
  begin
     if (FPosicaoMouseX > AwmMouseUp.XPos) then
     begin
       if Assigned(FOnEventoProximo) then
         FOnEventoProximo(Self);
     end
     else if (FPosicaoMouseX < AwmMouseUp.XPos) then
     begin
       if Assigned(FOnEventoAnterior) then
         FOnEventoAnterior(Self);
     end
  end;
end;

procedure TQuadro.CalcularImagemLogo;
var
  larguraBorda: Integer;
begin
 FObjetoLogo.Left := 0;
  FObjetoLogo.Top := 0;

  if (FObjetoLogo.Image.Width = 0) or
     (FObjetoLogo.Image.Height = 0) then
    Exit;

  larguraBorda := FBordaVertical.Width;

  if larguraBorda = 0 then
    Exit;

  FObjetoLogo.Left := larguraBorda;
  FObjetoLogo.Top := 2;
end;


end.
