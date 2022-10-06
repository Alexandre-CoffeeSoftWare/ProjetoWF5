unit fConfGravacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmConfGravacao = class(TForm)
    lbConfig: TLabel;
    imgIcon: TImage;
    rbQualidade: TRadioGroup;
    lbSalvar: TLabel;
    edtCaminhoSalvar: TEdit;
    btnBuscar: TButton;
    chkExibir: TCheckBox;
    btnFechar: TButton;
    btnSalvar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
  private
    {Classe fechada, chamada apenas por este}
    constructor Create(AOwner: TComponent);
  public
    class procedure ApresentarConfig;
  end;

implementation

var
  fmConfGravacao: TfmConfGravacao;

{$R *.dfm}

{ TForm1 }

class procedure TfmConfGravacao.ApresentarConfig;
begin
  if Assigned(fmConfGravacao) then
  begin
    fmConfGravacao.BringToFront;
    Exit;
  end;

  fmConfGravacao := TfmConfGravacao.Create(Application.MainForm);
  fmConfGravacao.ShowModal;
end;

procedure TfmConfGravacao.btnFecharClick(Sender: TObject);
begin
  Close;
end;

constructor TfmConfGravacao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TfmConfGravacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  fmConfGravacao := nil;
end;

end.
