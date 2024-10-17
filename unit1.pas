unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  ExtCtrls, StdCtrls, Buttons, FileCtrl, ComCtrls, ShellCtrls, mysql56conn,
  mysql55conn, sqldb, UTF8Process, process,
  //{$IFDEF UNIX}
  //cthreads, cmem,
  //{$ENDIF}
  //MTProcs,
  Types;



type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    FileListBox1: TFileListBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    MySQL55Connection1: TMySQL55Connection;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { private declarations }
    //ed1,ed2,ed3,dir:pchar;
    //pics,pics2: array of pchar;
    progress,progres:integer;
    aguarde,tmp,spin:string;

    procedure suporte;
    procedure moldura;
    procedure revisao;
    //procedure moldura_para(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
    procedure update_para;

  public
    { public declarations }
  end;

var
  Form1: TForm1;
  br: Boolean;
  OpDirRes: string;
  erros:TStringList;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.revisao;
var
  page:Graphics.TBitmap;
  cab:TImage;
  style:TTextStyle;
begin
  cab:=TImage.Create(self);
  page:=Graphics.TBitmap.Create;
  cab.Picture.LoadFromFile(DirectoryEdit1.Directory+'/'+ListBox1.GetSelectedText);

  page.Canvas.Brush.Color:=$ffffff;
  page.Canvas.Font.Height:=60;
  if cab.Picture.Height >= cab.Picture.Width then //vertical
  begin
    page.Height:=1600;
    page.Width:=1000;
    page.Canvas.FillRect(0,0,1000,1600);
    page.Canvas.StretchDraw(Rect(0,0,1000,1500),cab.Picture.Bitmap);
    page.Canvas.TextOut(50,1510,ListBox1.GetSelectedText+' | RF:'+Edit1.Text);
  end;
  if cab.Picture.Height < cab.Picture.Width then  //horizontal
  begin
    page.Height:=1100;
    page.Width:=1500;
    page.Canvas.FillRect(0,0,1500,1100);
    page.Canvas.StretchDraw(Rect(0,0,1500,1000),cab.Picture.Bitmap);
    page.Canvas.TextOut(50,1010,ListBox1.GetSelectedText+' | RF:'+Edit1.Text);
  end;

  Application.ProcessMessages;
  Image1.Picture.Bitmap.Assign(page);
  CreateDir(DirectoryEdit1.Directory+'/suporte');
  Image1.Picture.Jpeg.CompressionQuality:=70;
  Image1.Picture.SaveToFile(DirectoryEdit1.Directory+'/suporte/pag'+
    IntToStr(ListBox1.ItemIndex)+'.jpg');
  ListBox1.Items.Strings[ListBox1.ItemIndex]:='suporte/pag'+IntToStr(ListBox1.ItemIndex)+'.jpg';

  cab.Free;
  page.Free;
end;

// a simple parallel procedure
{procedure TForm1.moldura_para(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
var
  page:Graphics.TBitmap;
  cab,saver:TImage;
  style:TTextStyle;
  pic:pchar;
begin

          cab:=TImage.Create(self);
          saver:=TImage.Create(self);
          page:=Graphics.TBitmap.Create;
          cab.Picture.LoadFromFile(dir+'/'+pics[Index]);

          page.Canvas.Brush.Color:=$242424;
          page.Canvas.Font.Height:=20;
          page.Canvas.Font.Color:=$F0F0F0;
          if cab.Picture.Height >= cab.Picture.Width then
          begin
            page.Height:=1560;
            page.Width:=1000;
            page.Canvas.FillRect(0,0,1000,1560);
            page.Canvas.StretchDraw(Rect(0,0,1000,1500),cab.Picture.Bitmap);
            page.Canvas.TextOut(10,1506,'Fotógrafo Criminalístico: '+ed3+'   '+
              'Registro Fotográfico nº '+ed1);
            page.Canvas.TextOut(10,1535,'Instituto Geral de Perícias - RS');
            //if CheckBox2.Checked then
            //begin
            //  page.Canvas.TextOut(850,1510,'Foto nº '+IntToStr(Index+1));
            //end;
          end;
          if cab.Picture.Height < cab.Picture.Width then
          begin
            page.Height:=1060;
            page.Width:=1500;
            page.Canvas.FillRect(0,0,1500,1060);
            page.Canvas.StretchDraw(Rect(0,0,1500,1000),cab.Picture.Bitmap);
            page.Canvas.TextOut(10,1006,'Fotógrafo Criminalístico: '+ed3+'   '+
              'Registro Fotográfico nº '+ed1);
            page.Canvas.TextOut(10,1035,'Instituto Geral de Perícias - RS');
            //if CheckBox2.Checked then
            //begin
            //  page.Canvas.TextOut(1350,1010,'Foto nº '+IntToStr(Index+1));
            //end;
          end;
          page.Canvas.Font.Height:=12;
          page.Canvas.Font.Color:=$505050;
          page.Canvas.TextOut(page.Width-200,page.Height-20,'dev: guilherme de moraes alvarez, 2018.');
          saver.Width:=page.Width;
          saver.Height:=page.Height;
          saver.Picture.Bitmap.Assign(page);
          saver.Picture.Jpeg.CompressionQuality:=70+TrackBar1.Position*3;
          saver.Picture.SaveToFile(dir+'/suporte/pag'+
          FormatFloat('0000',Index)+'.jpg');

          page.Free;
          cab.Free;
          saver.Free;

          //pics2[Index]:='OK';
          //TThread.Synchronize(CurrentThread,@update_para);

end;   }

procedure TForm1.update_para;
begin

end;

procedure TForm1.moldura;
var
  page:Graphics.TBitmap;
  cab:TImage;
  style:TTextStyle;
begin
  cab:=TImage.Create(self);
  page:=Graphics.TBitmap.Create;
  cab.Picture.LoadFromFile(DirectoryEdit1.Directory+'/'+ListBox1.GetSelectedText);

  page.Canvas.Brush.Color:=$242424;
  page.Canvas.Font.Height:=20;
  page.Canvas.Font.Color:=$F0F0F0;
  if cab.Picture.Height >= cab.Picture.Width then
  begin
    page.Height:=1560;
    page.Width:=1000;
    page.Canvas.FillRect(0,0,1000,1560);
    page.Canvas.StretchDraw(Rect(0,0,1000,1500),cab.Picture.Bitmap);
    page.Canvas.TextOut(10,1506,'Fotógrafo Criminalístico: '+Edit3.Text+'   '+
      'Registro Fotográfico nº '+Edit1.Text);
    page.Canvas.TextOut(10,1535,'Instituto Geral de Perícias - RS');
    if CheckBox2.Checked then
    begin
      page.Canvas.TextOut(850,1510,'Foto nº '+IntToStr(ListBox1.ItemIndex+1));
    end;
  end;
  if cab.Picture.Height < cab.Picture.Width then
  begin
    page.Height:=1060;
    page.Width:=1500;
    page.Canvas.FillRect(0,0,1500,1060);
    page.Canvas.StretchDraw(Rect(0,0,1500,1000),cab.Picture.Bitmap);
    page.Canvas.TextOut(10,1006,'Fotógrafo Criminalístico: '+Edit3.Text+'   '+
      'Registro Fotográfico nº '+Edit1.Text);
    page.Canvas.TextOut(10,1035,'Instituto Geral de Perícias - RS');
    if CheckBox2.Checked then
    begin
      page.Canvas.TextOut(1350,1010,'Foto nº '+IntToStr(ListBox1.ItemIndex+1));
    end;
  end;
  page.Canvas.Font.Height:=12;
  page.Canvas.Font.Color:=$505050;
  page.Canvas.TextOut(page.Width-200,page.Height-20,'dev: guilherme de moraes alvarez, 2018.');

  Application.ProcessMessages;
  Image1.Picture.Bitmap.Assign(page);
  CreateDir(DirectoryEdit1.Directory+'/suporte');
  //Image1.Picture.Jpeg.Performance := jpbestquality;
  Image1.Picture.Jpeg.CompressionQuality:=70+TrackBar1.Position*3;
  Image1.Picture.SaveToFile(DirectoryEdit1.Directory+'/suporte/pag'+
    FormatFloat('0000',ListBox1.ItemIndex)+'.jpg');
  ListBox1.Items.Strings[ListBox1.ItemIndex]:='suporte/pag'+FormatFloat('0000',ListBox1.ItemIndex)+'.jpg';

  page.Free;
  cab.Free;
end;

procedure TForm1.suporte;
var
  page:Graphics.TBitmap;
  cab:TImage;
  style:TTextStyle;
  dpi10,h,w,a,b,c,d:integer;
begin
  dpi10:=StrToInt(Edit4.Text)div 10;
  w:=(StrToInt(Edit5.Text));
  h:=(StrToInt(Edit6.Text));
  page:=Graphics.TBitmap.Create;
  page.Width:=dpi10*w;
  page.Height:=dpi10*h;
  page.Canvas.Brush.Color:=clWhite;
  page.Canvas.FillRect(0,0,page.Width,page.Height);
  page.Canvas.Font.Name:='Helvetica';
  page.Canvas.Font.Size:=3*dpi10;
  page.Canvas.Font.Color:=clBlack;
  style:=page.Canvas.TextStyle;
  style.Alignment:=taRightJustify;
  style.SingleLine:=False;
  Application.ProcessMessages;
  //ShowMessage('fonte '+page.Canvas.Font.Name+' '+IntToStr(page.Canvas.Font.Size));
  page.Canvas.TextRect(Rect(page.Width-(90*dpi10),12*dpi10,page.Width-(12*dpi10),
    50*dpi10),page.Width-(90*dpi10),12*dpi10,'Registro Fotográfico nº '+Edit1.Text+LineEnding+Edit2.Text,style);
  page.Canvas.TextRect(Rect(12*dpi10,page.Height-(22*dpi10),
    page.Width-(12*dpi10),page.Height-(12*dpi10)),12*dpi10,page.Height-(22*dpi10),
    'Fotógrafo Criminalístico: '+Edit3.Text,style);
  if CheckBox2.Checked then
  begin
    style.Alignment:=taLeftJustify;
    page.Canvas.TextRect(Rect(12*dpi10,page.Height-(22*dpi10),
      page.Width-(12*dpi10),page.Height-(12*dpi10)),12*dpi10,page.Height-(22*dpi10),
      'Foto nº '+IntToStr(ListBox1.ItemIndex+1),style);
  end;
  //ShowMessage('texto escrito');
  cab:=TImage.Create(self);
  // OSX
  OpDirRes:= ExtractFileDir(ExtractFileDir(Application.ExeName))+'/Resources';
  cab.Picture.LoadFromFile(OpDirRes+'/cabecalho2.png');
  // WIN
  //cab.Picture.LoadFromFile('cabecalho2.png');
  ///////
  page.Canvas.StretchDraw(Rect(5*dpi10,5*dpi10,103*dpi10,27*dpi10),cab.Picture.Bitmap);
  cab.Picture.LoadFromFile(DirectoryEdit1.Directory+'/'+ListBox1.GetSelectedText);

  if cab.Picture.Height >= cab.Picture.Width then
  begin
    a:=47*dpi10;
    b:=65*dpi10;
    c:=(120*dpi10)+a;
    d:=(180*dpi10)+b;
  end;
  if cab.Picture.Height < cab.Picture.Width then
  begin
    a:=15*dpi10;
    b:=87*dpi10;
    c:=(180*dpi10)+a;
    d:=(120*dpi10)+b;
  end;
  page.Canvas.Font.Height:=1*dpi10;
  page.Canvas.TextOut(320,22,'dev: guilherme de moraes alvarez, 2018.');


  page.Canvas.StretchDraw(Rect(a,b,c,d),cab.Picture.Bitmap);
  Application.ProcessMessages;
  Image1.Picture.Bitmap.Assign(page);
  CreateDir(DirectoryEdit1.Directory+'/suporte');
  Image1.Picture.SaveToFile(DirectoryEdit1.Directory+'/suporte/pag'+
    IntToStr(ListBox1.ItemIndex)+'.png');
  ListBox1.Items.Strings[ListBox1.ItemIndex]:='suporte/pag'+IntToStr(ListBox1.ItemIndex)+'.png';

  page.Free;
  cab.Free;

end;

procedure TForm1.DirectoryEdit1Change(Sender: TObject);
begin
  FileListBox1.Directory:=DirectoryEdit1.Directory;
  //ShowMessage(FileListBox1.Directory);
  FileListBox1.ItemIndex:=0;
  FileListBox1Change(self);
  Edit1.Text:=copy(DirectoryEdit1.Directory,LastDelimiter('\',DirectoryEdit1.Directory)+1,4)+
    '/20'+copy(DirectoryEdit1.Directory,LastDelimiter('\',DirectoryEdit1.Directory)+6,2);
  Edit2.Text:=copy(DirectoryEdit1.Directory,LastDelimiter('_',DirectoryEdit1.Directory)-6,6)+
    '/20'+copy(DirectoryEdit1.Directory,length(DirectoryEdit1.Directory)-1,2);
  {$ifdef DARWIN}
    Edit1.Text:=copy(DirectoryEdit1.Directory,LastDelimiter('/',DirectoryEdit1.Directory)+1,4)+
      '/20'+copy(DirectoryEdit1.Directory,LastDelimiter('/',DirectoryEdit1.Directory)+6,2);
  {$endif}
end;

procedure TForm1.FileListBox1Change(Sender: TObject);
begin
  ListBox1.Items.Assign(FileListBox1.Items);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  user:string;
begin
  //if Date > StrToDate('2015/12/01') then
  //begin
    //ShowMessage('Este programa expirou. Entre em contato com o desenvolvedor.');
    //Application.Terminate;
  //end;
  OpDirRes:='';
  {$ifdef DARWIN}
    OpDirRes:=ExtractFileDir(ExtractFileDir(Application.ExeName))+'/Resources/';
  {$endif}
  //ShowMessage(OpDirRes);

  Image1.Picture.Bitmap.Width:=Image1.Width;
  Image1.Picture.Bitmap.Height:=Image1.Height;
  Image1.Picture.Bitmap.Canvas.Brush.Color:=$383838;
  Image1.Picture.Bitmap.Canvas.FillRect(0,0,Image1.Width,Image1.Height);
  Image1.Picture.Bitmap.Canvas.Font.Height:=30;
  Image1.Picture.Bitmap.Canvas.Font.Color:=$F0F0F0;

  {$IFDEF windows}
    RunCommand('c:\windows\system32\cmd.exe', ['/c', 'net user '+GetEnvironmentVariable('username')+
      ' /domain | findstr completo'], user);

    Edit3.Text:=Trim(copy(user,pos('   ',user)+3,length(user)-pos('   ',user)));
  {$ENDIF}
  {$IFDEF darwin}
    Edit3.Text:='Diogo Batista Medeiros Schmidt';
  {$ENDIF}
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  try
    Image1.Picture.LoadFromFile(DirectoryEdit1.Directory+'/'+ListBox1.GetSelectedText);

  except
  end;
end;

procedure TForm1.ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if CheckBox1.Checked then Moldura else suporte;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  i,j,k,l:integer;
  myserv:TStringList;
  arrstr: array of string;

  thr:TProcessUTF8;
begin
  // ANOTAR NO SERVFOTO MYSQL AS INFORMAÇOES DO LOCAL
  // CONECTA NO SERVFOTO MYSQL
  {try
  MySQL55Connection1.HostName:='10.15.96.149';
  myserv:=TStringList.Create;
  if FileExists(OpDirRes+'servfoto.txt') then
  begin
    myserv.LoadFromFile(OpDirRes+'servfoto.txt');
    MySQL55Connection1.HostName:=myserv.Strings[0];
  end;
  MySQL55Connection1.DatabaseName:='locais';
  MySQL55Connection1.UserName:='suporte';
  MySQL55Connection1.Password:='31072009';
  MySQL55Connection1.Connected:=True;
  myserv.Free;
  except
    on E: Exception do
    begin
      //ShowMessage('nao rolou connect.');
      erros:=TStringList.Create;
      if FileExists(OpDirRes+'errosMySQL.txt') then erros.LoadFromFile(OpDirRes+'errosMySQL.txt');
      erros.Add(DateToStr(now)+': falhou no connect');
      erros.Add(E.message);
      //WINDOWS erros.SaveToFile('errosMySQL.txt');
      erros.SaveToFile(OpDirRes+'errosMySQL.txt');
      erros.free;
    end;
  end;

  try
  SQLQuery1.SQL.Text:='insert into pastas_suporte values(null,"'+DirectoryEdit1.Directory+
    '","'+FormatDateTime('yyyy-mm-dd',now)+'","'+GetUserDir+'",'+IntToStr(FileListBox1.Count)+',"");';
  SQLQuery1.SQL.Text:=StringReplace(SQLQuery1.SQL.Text,'\','\\',[rfReplaceAll]);
  SQLQuery1.ExecSQL;
  SQLTransaction1.Commit;
  except
    on E: Exception do
    begin
      //ShowMessage('nao rolou insert.');
      erros:=TStringList.Create;
      if FileExists(OpDirRes+'errosMySQL.txt') then erros.LoadFromFile(OpDirRes+'errosMySQL.txt');
      erros.Add(DateToStr(now)+': falhou no insert');
      erros.Add(SQLQuery1.SQL.Text);
      erros.Add(E.message);
      // WINDOWS erros.SaveToFile('errosMySQL.txt');
      erros.SaveToFile(OpDirRes+'errosMySQL.txt');
      erros.free;

    end;
  end; }
  ////////////////////////////
  br:=False;
  {dir:=pchar(DirectoryEdit1.Directory);
  ed1:=pchar(Edit1.Text);
  ed2:=pchar(Edit2.Text);
  ed3:=pchar(Edit3.Text);
  SetLength(pics,ListBox1.Count);
  SetLength(pics2,ListBox1.Count);
  SetLength(arrstr,ListBox1.Count);
  for i:=0 to ListBox1.Count-1 do
  begin
    arrstr[i]:=ListBox1.Items.Strings[i];
  end;
  for i:=0 to ListBox1.Count-1 do
  begin
    pics[i]:=pchar(arrstr[i]);
    pics2[i]:='...';
  end;}
  CreateDir(DirectoryEdit1.Directory+'/suporte');
  progress:=ListBox1.Count;
  progres:=0;

  Image1.Picture.Bitmap.Canvas.TextOut(100,300,'Aguarde...');
  Image1.Picture.Bitmap.Canvas.Refresh;
  Image1.Refresh;
  Application.ProcessMessages;
  //Timer1.Enabled:=True;

  //ProcThreadPool.DoParallel(@form1.moldura_para,0,ListBox1.Count-1,nil,4); // address, startindex, endindex, optional data
  {RunCommand('thread.exe', [DirectoryEdit1.Directory, Edit1.Text,Edit3.Text,
    inttostr(70+TrackBar1.Position*3),IntToStr(ListBox1.Count-1)],
    tmp,[poUsePipes]);
  }
  //ifdef mac ProcThreadPool.DoParallel(@form1.moldura_para,0,n,nil,4); // address, startindex, endindex, optional data

  thr:=TProcessUTF8.Create(nil);
  {$IFDEF windows}
    thr.Executable:='thread.exe';
  {$ENDIF}
  {$IFDEF darwin}
    thr.Executable:=OpDirRes+'/thread';
  {$ENDIF}
  thr.Parameters.Add(DirectoryEdit1.Directory+'.');
  thr.Parameters.Add(Edit1.Text+'.');
  thr.Parameters.Add(Edit3.Text+'.');
  thr.Parameters.Add(inttostr(70+TrackBar1.Position*3));
  thr.Parameters.Add(IntToStr(ListBox1.Count-1));
  thr.Parameters.Add(Edit2.Text+'.');
  thr.Options:=[poWaitOnExit];


  ListBox1.Clear;
  FileListBox1.Directory:=DirectoryEdit1.Directory+'/suporte';
  FileListBox1.UpdateFileList;
  FileListBox1Change(self);

  Application.ProcessMessages;

  thr.Execute;

  {while thr.Running do
  begin
    Application.ProcessMessages;
  end;
  }
  Timer1.Enabled:=False;
  FileListBox1.UpdateFileList;
  FileListBox1Change(self);
  for i:=0 to ListBox1.Count-1 do ListBox1.Items.Strings[i]:='suporte/'+ListBox1.Items.Strings[i];
  Image1.Picture.Bitmap.Canvas.FillRect(0,0,Image1.Width,Image1.Height);
  try
    Image1.Picture.LoadFromFile(DirectoryEdit1.Directory+'/'+ListBox1.Items.Strings[ListBox1.Count-1]);
  except
  end;


  //ShowMessage('Pronto');

  {for i:=0 to ListBox1.Count-1 do
  begin
    if br = True then
    begin
      br:=False;
      break;
    end;
    ListBox1.Selected[i]:=True;
    if copy(ListBox1.GetSelectedText,1,8) <> 'suporte/' then
    begin
      if CheckBox3.Checked then revisao
      else if CheckBox1.Checked then moldura
      else suporte;
    end;
  end;}
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
   br := true;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  i:integer;
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
  Image1.Picture.Clear;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  DirectoryEdit1Change(self);
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //ShowMessage('timer!');
  spin:=spin+'|';
  if spin = '||||||||||' then spin := '|';
  Image1.Picture.Bitmap.Canvas.FillRect(100,300,300,400);
  Image1.Picture.Bitmap.Canvas.TextOut(100,300,'Aguarde '+spin);


  FileListBox1.UpdateFileList;
  FileListBox1Change(self);

  {try
    Image1.Picture.LoadFromFile(FileListBox1.Directory+'/'+ListBox1.Items.Strings[ListBox1.Count-1]);
  finally
  end;}

  //Application.ProcessMessages;
end;

end.

