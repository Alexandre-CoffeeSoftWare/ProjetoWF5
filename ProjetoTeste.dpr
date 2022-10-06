program ProjetoTeste;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {fmMain},
  uQuadro in 'COMP_QUADRO\uQuadro.pas',
  uObjetoImage in 'COMP_QUADRO\uObjetoImage.pas',
  fConfGravacao in 'fConfGravacao.pas' {fmConfGravacao},
  fAjusteProjecao in 'fAjusteProjecao.pas' {frmAjusteProjecao},
  fFechar in 'fFechar.pas' {frmFechar},
  uCaixaDesenho in 'uCaixaDesenho.pas' {frmCaixaDesenho},
  uGravarDados in 'uGravarDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
