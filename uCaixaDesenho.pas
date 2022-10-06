unit uCaixaDesenho;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TfrmCaixaDesenho = class(TForm)
    gdListaIcones: TGridPanel;
    pnTopo: TPanel;
    spTopo: TShape;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    pnBaixa: TPanel;
    Image14: TImage;
    Image15: TImage;
    procedure spTopoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure gdListaIconesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image15MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure spTopoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    procedure WmnChildTest(var wmChildTest: TWMNCHitTest); message WM_NCHITTEST;
    procedure MoverForm;
  public
    class procedure ApresentarCaixa(AparentControl: TWinControl);
  end;

implementation

var
  frmCaixaDesenho: TfrmCaixaDesenho;

{$R *.dfm}

{ TfrmCaixaDesenho }

procedure TfrmCaixaDesenho.spTopoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MoverForm;
end;

procedure TfrmCaixaDesenho.spTopoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowMessage(Self.Left.ToString + ' ' + Self.Top.ToString);
end;

procedure TfrmCaixaDesenho.WmnChildTest(var wmChildTest: TWMNCHitTest);
begin
  inherited;
  if wmChildTest.Msg = HTCLIENT then
    wmChildTest.Result := HTCLIENT;
end;

class procedure TfrmCaixaDesenho.ApresentarCaixa(AparentControl: TWinControl);
begin
  if Assigned(frmCaixaDesenho) then
  begin
    frmCaixaDesenho.BringToFront;
    exit;
  end;

  frmCaixaDesenho := TfrmCaixaDesenho.Create(Application.MainForm);
  frmCaixaDesenho.Parent := AparentControl;
  frmCaixaDesenho.Show;
end;

procedure TfrmCaixaDesenho.FormShow(Sender: TObject);
begin
  Self.Left := Trunc(Parent.Width * 0.75);
  Self.Top := Trunc(Parent.Height * 0.45)
end;

procedure TfrmCaixaDesenho.gdListaIconesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MoverForm;
end;

procedure TfrmCaixaDesenho.Image15MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MoverForm;
end;

procedure TfrmCaixaDesenho.MoverForm;
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_SYSCOMMAND, 61458, 0);
end;

end.
