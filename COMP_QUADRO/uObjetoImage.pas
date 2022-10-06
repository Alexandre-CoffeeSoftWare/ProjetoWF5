unit uObjetoImage;

interface

uses
  Winapi.Windows, Vcl.Graphics;

type
  TObjetoImage = class
  private
    FImage: TBitmap;
    FPosicao: TRect;
    FAtualizar: Boolean;
    FVisivel: Boolean;
    function GetImage: TBitmap;
    function GetVisivel: Boolean;
  public
    constructor Create;
    destructor Destroy;override;
    class procedure RetocionarImagem90G(const AImgOrigem: TBitmap;const AImgDestino: TBitmap);
    property Image: TBitmap read GetImage;
    property Top: Integer read FPosicao.Top write FPosicao.Top;
    property Left: Integer read FPosicao.Left write FPosicao.Left;
    property Visivel: Boolean read GetVisivel;
  end;

implementation

{ TObjetoImage }

constructor TObjetoImage.Create;
begin
  FImage := TBitmap.Create;
  FAtualizar := True;
  FVisivel := False;
end;

destructor TObjetoImage.Destroy;
begin
  FImage.Free;
  inherited;
end;

function TObjetoImage.GetImage: TBitmap;
begin
  FAtualizar := True;
  Result := FImage;
end;

function TObjetoImage.GetVisivel: Boolean;
begin
  if FAtualizar then
  try
    Result := (FImage.Width > 0) and (FImage.Height > 0);
  finally
    FAtualizar := False;
  end;
end;

class procedure TObjetoImage.RetocionarImagem90G(const AImgOrigem: TBitmap;const AImgDestino: TBitmap);
var
  imgPosX: Integer;
  imgPosY: Integer;
  imgWidth: Integer;
  imgHeight: Integer;
begin
  AImgDestino.Width := AImgOrigem.Height;
  AImgDestino.Height := AImgOrigem.Width;
  imgWidth := AImgOrigem.Width - 1;
  imgHeight := AImgOrigem.Height;
  AImgDestino.Canvas.Lock;
  try
    for imgPosX := 0 to imgWidth do
      for imgPosY := 0 to imgHeight do
        AImgDestino.Canvas.Pixels[imgPosY, imgWidth - imgPosX] := AImgOrigem.Canvas.Pixels[imgPosX, imgPosY];
  finally
    AImgOrigem.Canvas.Unlock;
  end;
end;

end.
