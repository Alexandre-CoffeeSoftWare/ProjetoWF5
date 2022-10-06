unit fFechar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TRetornoTelaSair = (rtsSalvarSair, rtsSair, rtsCancelar);

type
  TfrmFechar = class(TForm)
    imgIcon: TImage;
    lbConfig: TLabel;
    Label1: TLabel;
    btnSalvarESair: TButton;
    btnSair: TButton;
    btnCancelar: TButton;
    procedure btnSalvarESairClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FTipoAcao: TRetornoTelaSair;
  public
    class function ApresentarTelaFechar: TRetornoTelaSair;
  end;

implementation

var
  frmFechar: TfrmFechar;

{$R *.dfm}

class function TfrmFechar.ApresentarTelaFechar: TRetornoTelaSair;
begin
  frmFechar := TfrmFechar.Create(Application.MainForm);
  try
    frmFechar.ShowModal;
    Result := frmFechar.FTipoAcao;
  finally
    frmFechar.Free;
  end;
end;

procedure TfrmFechar.btnCancelarClick(Sender: TObject);
begin
  FTipoAcao := rtsCancelar;
  ModalResult := mrOk;
end;

procedure TfrmFechar.btnSairClick(Sender: TObject);
begin
  FTipoAcao := rtsSair;
  ModalResult := mrOk;
end;

procedure TfrmFechar.btnSalvarESairClick(Sender: TObject);
begin
  FTipoAcao := rtsSalvarSair;
  ModalResult := mrOk;
end;

end.
