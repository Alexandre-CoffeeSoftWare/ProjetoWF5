unit fAjusteProjecao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TTipoAjuste = (tajSuperior, tajInferior);

const
  NOME_TIPOAJUSTE : array [Low(TTipoAjuste)..high(TTipoAjuste)] of string = ('Superior', 'Inferior');

type
  TfrmAjusteProjecao = class(TForm)
    tkAjuste: TTrackBar;
    lbCaptionAjuste: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    {Class fechada, não chama por fora}
    Constructor Create(Aowner: TComponent);
  public
    class procedure ApresentarAjuste(ATipoAjuste: TTipoAjuste;AParent: TControl);
    class procedure FecharTela;
    class function IsActive: Boolean;
  end;

implementation

uses
  StrUtils;

var
  frmAjusteProjecao: TfrmAjusteProjecao;

{$R *.dfm}

{ TfrmAjusteProjecao }

class procedure TfrmAjusteProjecao.ApresentarAjuste(ATipoAjuste: TTipoAjuste;AParent: TControl);
begin
  if Assigned(frmAjusteProjecao) then
    Exit;

  frmAjusteProjecao := TfrmAjusteProjecao.Create(Application.MainForm);
  frmAjusteProjecao.Parent := AParent.Parent;
  frmAjusteProjecao.lbCaptionAjuste.Caption := Format('Ajuste %s de Projeção', [NOME_TIPOAJUSTE[ATipoAjuste]]);
  frmAjusteProjecao.Show;
  frmAjusteProjecao.Left := ((AParent.Width div 2)-(frmAjusteProjecao.Width div 2));
  frmAjusteProjecao.Top := (AParent.Height div 2);
  frmAjusteProjecao.Repaint;
end;

constructor TfrmAjusteProjecao.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
end;

class procedure TfrmAjusteProjecao.FecharTela;
begin
  if Assigned(frmAjusteProjecao) then
    frmAjusteProjecao.Close;
end;

procedure TfrmAjusteProjecao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmAjusteProjecao := nil;
end;

class function TfrmAjusteProjecao.IsActive: Boolean;
begin
  Result := Assigned(frmAjusteProjecao);
end;



end.
