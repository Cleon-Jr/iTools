unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Samples.Gauges, Vcl.WinXPickers,
  Vcl.Imaging.pngimage;

type
  Tmain = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    Shape1: TShape;
    Label3: TLabel;
    ComboBox1: TComboBox;
    BitBtn2: TBitBtn;
    Edit2: TEdit;
    Label4: TLabel;
    BitBtn3: TBitBtn;
    Gauge1: TGauge;
    Shape2: TShape;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    ComboBox2: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Label8: TLabel;
    BitBtn4: TBitBtn;
    Label10: TLabel;
    DateTimePicker2: TDateTimePicker;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Image1: TImage;
    Label11: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  main: Tmain;

implementation

{$R *.dfm}

uses uDM;

procedure Tmain.BitBtn1Click(Sender: TObject);
var
instituicao: string;

begin
openDialog1.Execute;

  if(openDialog1.FileName <> '')then
    begin
      if(FileExists(OpenDialog1.FileName))then
        begin
          edit1.Text:= OpenDialog1.FileName;
          DM.Connection.Params.Database:= OpenDialog1.FileName;

          try
            DM.Connection.Connected:= true;
            DM.Connection.Open;
            label2.Caption:= 'Conectado';
            label2.Font.Color:= clGreen;

            instituicao:= DM.Connection.ExecSQLScalar('select first 1 * from empresa');
            panel1.Caption:= ' iTools - ' + instituicao;

            TabSheet2.Enabled:= true;

          except on E: Exception do
            application.MessageBox(PChar('N�o foi poss�vel se conectar com o banco de dados! ' + E.Message), 'iTools | Erro', MB_ICONERROR + MB_OK);
          end;
          abort;
        end;
    end;


end;

procedure Tmain.BitBtn2Click(Sender: TObject);
var
qry, nro: string;
qnt, count: integer;

begin
qry:= 'select distinct coalesce(fmov.mtc_numero_ato, 0) as nroato ' +
      'from funcionario_movtc fmov order by fmov.mtc_numero_ato';


count:= 0;

with(DM.sqlFuncionario)do
  begin
    Close;
    SQL.Clear;
    SQL.Add(qry);
    Open;

    while not(Eof)do
      begin
        count:= count + 1;
        Gauge1.Progress:= count;
        ComboBox1.Items.Add(FieldByName('nroato').AsString);
        Next;
      end;

  end;

  Gauge1.Progress:= 0;

end;

procedure Tmain.BitBtn3Click(Sender: TObject);
var
qry: string;

begin
  if(CheckBox1.Checked)then
    begin
      qry:= 'update funcionario_movtc fmov ' +
            'set fmov.mtc_numero_ato = :nrato, fmov.mtc_data_publicacao = :dtpublicacao ' +
            'where fmov.mtc_numero_ato = :nrato_antigo';
    end
    else
    begin
      qry:= 'update funcionario_movtc fmov ' +
            'set fmov.mtc_numero_ato = :nrato ' +
            'where fmov.mtc_numero_ato = :nrato_antigo';
    end;


    with(DM.sqlFuncionario)do
      begin
        Close;
        SQL.Clear;
        SQL.Add(qry);
        ParamByName('nrato').AsString:= edit2.Text;
        ParamByName('nrato_antigo').AsString:= ComboBox1.Text;
        if(CheckBox1.Checked)then
          begin
            ParamByName('dtpublicacao').AsString:= FormatDateTime('dd.mm.yyyy', DateTimePicker2.date);
          end;
        ExecSQL;

        if(RowsAffected > 0)then
          begin
            application.MessageBox('Altera��o realizada com sucesso!','iTools | Sucesso', MB_ICONEXCLAMATION + MB_OK);
          end
          else
          begin
            application.MessageBox('Erro ao tentar alterar!','iTools | Erro', MB_ICONERROR + MB_OK);
            abort;
          end;
      end;

qry:= 'select distinct coalesce(fmov.mtc_numero_ato, 0) as nroato ' +
      'from funcionario_movtc fmov order by fmov.mtc_numero_ato';

ComboBox1.Items.Clear;

with(DM.sqlFuncionario)do
  begin
    Close;
    SQL.Clear;
    SQL.Add(qry);
    Open;

    while not(Eof)do
      begin
        ComboBox1.Items.Add(FieldByName('nroato').AsString);
        Next;
      end;

  end;

end;

procedure Tmain.BitBtn4Click(Sender: TObject);
var
qry, matriculas: string;
tipo_ato: integer;

begin
matriculas:= edit3.Text;

qry:= 'update funcionario_movtc fmov ' +
      'set fmov.tal_codigo = :talcod, fmov.mtc_numero_ato = :nrato, fmov.mtc_data_publicacao = :dtpublicacao ' +
      'where fmov.matricula in(' + matriculas + ')';

  if(ComboBox2.ItemIndex = 0)then
    begin
      tipo_ato:= 1;
    end;
  if(ComboBox2.ItemIndex = 1)then
    begin
      tipo_ato:= 2;
    end;
  if(ComboBox2.ItemIndex = 2)then
    begin
      tipo_ato:= 4;
    end;
  if(ComboBox2.ItemIndex = 3)then
    begin
      tipo_ato:= 5;
    end;
  if(ComboBox2.ItemIndex = 4)then
    begin
      tipo_ato:= 9;
    end;
  if(ComboBox2.ItemIndex = 5)then
    begin
      tipo_ato:= 2;
    end;


    with(DM.sqlFuncionario)do
      begin
        Close;
        SQL.Clear;
        SQL.Add(qry);
        ParamByName('talcod').AsString:= inttostr(tipo_ato);
        ParamByName('nrato').AsString:= edit4.Text;
        ParamByName('dtpublicacao').AsString:= FormatDateTime('dd.mm.yyyy', DateTimePicker1.Date);
       // ParamByName('matricula').AsString:= edit3.Text;
        ExecSQL;

        if(RowsAffected > 0)then
          begin
            application.MessageBox('Altera��o realizada com sucesso!','iTools | Sucesso', MB_ICONEXCLAMATION + MB_OK);
          end
          else
          begin
            application.MessageBox('Erro ao tentar alterar!','iTools | Erro', MB_ICONERROR + MB_OK);
            Abort;
          end;
      end;


end;


procedure Tmain.BitBtn5Click(Sender: TObject);
begin
DM.Connection.Connected:= false;
label2.Caption:= 'Desconectado';
label2.Font.Color:= clRed;
TabSheet2.Enabled:= false;
end;

procedure Tmain.BitBtn6Click(Sender: TObject);
begin
  if(DM.Connection.Connected = true)then
    begin
      DM.Connection.Connected:= false;
      Application.Terminate;
    end
    else
    begin
      Application.Terminate;
    end;
end;

procedure Tmain.CheckBox1Click(Sender: TObject);
begin
  if(CheckBox1.Checked)then
    begin
      DateTimePicker2.Enabled:= true;
    end
    else
    begin
      DateTimePicker2.Enabled:= false;
    end;
end;

procedure Tmain.FormShow(Sender: TObject);
begin
PageControl1.TabIndex:= 0;

TabSheet2.Enabled:= false;

DateTimePicker1.Date:= now;
DateTimePicker2.Date:= now;
end;

end.
