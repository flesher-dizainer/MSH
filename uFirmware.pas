unit uFirmware;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, RzListVw, StdCtrls, Grids, RzGrids, ExtCtrls, RzPanel, RzTabs,
  InIFiles, RzButton, RzCommon, Mask, RzEdit, RzCmboBx;// uEducationThread;

// �������� �����
type
  TWorkPoint = record
    Count: integer;  // ���������� ��������� � �������� �����
    RMPArray: array of real;  // �������� ��������
    ThrottlePosArray: array of real;  // �������� ��������� ��������
    FillingValueArray: array of real;  // �������� ����������
    CorrectionValueArray: array of real;  // �������� ���������
  end;

  type
   Data_Table = record
    ID_CTE:string;//id ���������� ��� ������� � CTP
    Addr:word;//����� �������
    dad:boolean;//������� �� ���
    load_count:integer;//���������� ����� �� ��� ��������
    TPS:boolean;//������� �� ��������
    RPM_count:integer;//���������� ����� �� ��� ��������
    BCN:boolean;//������� �� ���
    �ount:integer;//������ �������
    mnozitel:integer;//���������
    delitel:integer;//��������
    sum:integer;//���� ��������
    addr_pcn_tps:integer;
    addr_pcn_dad:integer;
    //--------��� ����---------
    IntOpen,IntClose,EXOP,EXCL:integer;//���� �������� � �������� �������
    BoolWriteInj:boolean;

  end;


type
  TFirmware = class
    private
    public
    FdadNaklon:real;//������ �������������� ���
    FdadSMeshenie:real;//�������� �������������� ���
    FRPMAxis: array [1..16] of integer;//�������� ��������
    FRPMAxis_32: array[1..32] of integer;//�������� �������� 32
    FThrottleAxis: array [1..16] of integer;//�������� ��� ��������
    FThrottleAxis_32: array [1..32] of integer;//�������� ��� ��������
    FDADAxis: array [1..16] of integer; // �������� �� ��� ��������
    FdadAxis_32: array [1..32] of integer; //�������� ��� �������� �32
    FBCNAxis: array [1..16] of integer;
    FFirmwareData: array of byte;  // ����������� ��������
    FFirmwareWriteOlt: array of byte;//���������� ��� ������ � ���
    MIN_PCN,MAX_PCN,AVG_PCN,min_table,max_table,avg_table:real;
    Type_Table_ID:integer;
      function  LoadFirmware( FileName: string ): boolean;  // �������� ��������
      procedure CorrectCRC(var AFirmware: array of byte);//������� ����������� ����� ��������
      procedure NaklonDAD(addr_naklon: Word; addr_smeshenie: Word);//����� ������ ���
      procedure NaklonDAD_J7ES(naklon:word; smeshenie:word);//����� ������ ��� J7ES

      procedure GetTable(Table:TstringGrid; StartAddr:word; delitel:real; mnozitel:real; count:integer; sum:real);
      function  GetAfrXX(Data:byte):real;//���������� ����� � ����� ��������

      Function  GetQuantValue():integer;  // ��������� ��������� �����������
      procedure GetRPMAxis;//��������� ��� ��������
      procedure GetThrottleAxis;  // ��������� ��� ��������
      procedure GetThrottleAxis_32;//��������� ��� �������� �� 32 �����
      Procedure GetDadAxis(startaddrMin1:word; StartAddrMin2:word; StartAddrMax:word;OBR_MUL:integer);
      Procedure GetDadAxis_x32(startaddrMin1:word; StartAddrMin2:word; StartAddrMax:word;OBR_MUL:integer);
      procedure GetGBCAxis;//��������� ��� ����������
      function  ReadSwidFirmware():string;//��������� swid ��������
      function  ReadBitFirmware(addr:integer; bit_number:integer):boolean;//���������� ����� � ��������
      function  ParsingFirmware(swid:string):boolean;//����������� ������� ��������
      procedure Clear_DATA(var data : data_table);//������� ������ ������
      procedure WriteDataPcn(Acol:integer;Arow:integer;summa:boolean);//������ ������ ������� �������� ��
      procedure WriteDataUOZ(Acol: Integer; Arow: Integer;summa:boolean);//������ ��������� ���
      //WriteDataAFR
      procedure WriteDataAFR(Acol: Integer; Arow: Integer;summa:boolean);//������ ��������� AFR
      procedure InterpolateTablePcn;//����������� ������� ���
      procedure InterpolateTableBcn;//����������� ������� ���
      procedure GeneratorUoz(flag_afr:boolean);//������������� ��� �� ��� ���, ���
      function ReadvalueData_1D(Type_ID:integer;ADRR_CALIB:integer;OBR_MULT:real;delitel:real;MNOZITEL:real;SMESHENIE:real;smeshenie_2DATA:real):real; //���������� �������� �� ��������
      procedure WriteValueData_1D(Type_ID:integer;ADRR_CALIB:integer;OBR_MULT:real;delitel:real;MNOZITEL:real;SMESHENIE:real;smeshenie_2DATA:real;Data_VAL:double);
      function ReadNameOC_X(name:string;count_ToX:integer;number_TOX:integer):string;
      function ReadID_1(addr:integer;count_TOX:integer;NumberX:integer;FQuantValue:integer):integer;
      function ReadID_6(addr:integer;count_tox:integer;number:integer):integer;
      function ReadID_3(addr1:integer;addr2:integer;count_tox:integer;number:integer):integer;
      function InterpolateData(data1:integer;Data2:integer;Coeff:real):integer;//������������ ���� �����
      end;



  var
  BCN_DATA,PCN_DATA,AFR_DATA,UOZ_DATA,faza_data,hip_at,PC_GEN : data_table;
  //EducationThread : TEducationThread;

implementation
uses main;
{ TFirmware }

//�������� ��������
function TFirmware.LoadFirmware( FileName: string ): boolean;//�������� ��������
var
  i, Count: integer;
  a: cardinal;
  b: byte;
  f: THandle;
 // FirmSwid:string;
begin
  // ��������� ������� �����
  if FileExists( FileName ) then begin
    // ��������� ����
    f := CreateFile( PChar( FileName ), Generic_Read, 0, nil, Open_Existing, File_Attribute_Normal, 0 );
    Count := GetFileSize( f, nil );
   if count < 65536 then begin
    ShowMessage('�������� ������ ��������');
    exit(false);
   end;

    SetLength( FFirmwareData, 0 );
    SetLength( FFirmwareData, Count );
    // ��������� ������ ������
    for i := 1 to Count do begin
      ReadFile( f, b, SizeOf( b ), a, nil );
      FFirmwareData[ i-1  ] := b;
    end;
    // ��������� ����
    CloseHandle( f );
    ///


   for i := $5F00 to $A000 - 1 do begin
    setlength(FFirmwareWriteOlt,i+1-$5F00);
    FFirmwareWriteOlt[i-$5f00]:=FFirmwareData[i];
    end;
    ///
    GetRPMAxis;//�������� ��� ��������
    GetThrottleAxis;//�������� ��� ��������  �� 16
    GetThrottleAxis_32;//�������� ��� �������� �� 32
    GetDadAxis($5ef2,$5ef3,$5ef4,81946);//�������� ��� �������� �� 16
    GetDadAxis_x32($5ef2,$5ef3,$5ef4,82485);//�������� ��� �������� �� 32
    GetGBCAxis;
    result:=ParsingFirmware(ReadSwidFirmware);
  end else
    Result := false;
end;
//������� ����������� ����� �������� ����� �����������
procedure Tfirmware.CorrectCRC(var AFirmware: array of byte);
var
  i: integer;
  CRC: integer;
  Byte1, Byte2, mByte1, mByte2: Byte;
begin
  if Length( AFirmware ) <> 65536 then Exit;

  CRC := $00;
  for i := 0 to Length( AFirmware ) - 1 do begin
    if ( i <> $FFFE ) and ( i <> $FFFF ) then
      CRC := CRC + AFirmware[ i ]
    else begin
      if i = $FFFE then
        CRC := CRC + ( $FF - AFirmware[ $FFFA ] );

      if i = $FFFF then
        CRC := CRC + ( $FF - AFirmware[ $FFFB ] );
    end;
  end;

  Byte2 :=lo( CRC shr 8);
  Byte1 := CRC and $FF;
  AFirmware[ $FFFE ] := Byte1;
  AFirmware[ $FFFF ] := Byte2;

  mByte2 := $FF - Byte2;
  mByte1 := $FF - Byte1;
  AFirmware[ $FFFA ] := mByte1;
  AFirmware[ $FFFB ] := mByte2;
end;

//�������� ������ � �������� ���
procedure tfirmware.NaklonDAD(addr_naklon: Word; addr_smeshenie: Word);
begin
FdadNaklon:=(FFirmwareData[ addr_naklon ] + 256 * FFirmwareData[ addr_naklon + 1 ]) / 500;
FdadSMeshenie:=(FFirmwareData[ addr_smeshenie ] / 256)*5;
end;
//���������� ������ � �������� ��� � �������� j7es ����� ��� ���������� �������� � ����������� � ����������� ��
procedure tfirmware.NaklonDAD_J7ES(naklon: Word; smeshenie: Word);
begin
FdadNaklon:=(FFirmwareData[ naklon ] + 256 * FFirmwareData[ naklon + 1 ]) / 125;
FdadSMeshenie:=((FFirmwareData[ smeshenie ] + 256 * FFirmwareData[ smeshenie + 1 ]) / 1024)*5;
end;
 //�������� ������ � �������
procedure Tfirmware.GetTable(table: TStringGrid; StartAddr: Word; delitel: Real; mnozitel: Real; count:integer;sum:real);
 var
i:integer;
j,k:real;
dat:integer;
//Valda:real;
begin
 j:=0;
 k:=0;
if count = 255 then begin
table.ColCount:=17;
Table.RowCount:=17;
for i := 1 to 16 do begin
 table.Cells[i,0]:=intToStr(FRPMAxis[i]);
 //--------------------------------------
  if table.Name = 'SG_COEFF' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //----------------------------------------
  if Table.Name = 'SG_BCN' then begin
   if bcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if bcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if bcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
  end;
 //-----------------------------------------
 if table.Name = 'SG_PCN' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //--------------------------------------------
 if Table.name = 'SG_UOZ' then begin
   if uoz_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if uoz_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if uoz_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //---------------------------------------------
 if Table.name = 'SG_AFR' then begin
   if afr_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if afr_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if afr_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //----------------------------------------------
  if Table.name = 'SG_FAZA' then begin
   if faza_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if faza_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if faza_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //-----------------------------------------------------
end;
end;

if count = 511 then begin
table.ColCount:=33;
Table.RowCount:=17;
for i := 1 to 32 do table.Cells[i,0]:=IntToStr(FRPMAxis_32[i]);
//--------------------------------------------------------------------------
 for i := 1 to 16 do begin
  if Table.Name = 'SG_BCN' then begin
   if bcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if bcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if bcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
  end;
  //-------------------------------------
   if table.Name = 'SG_COEFF' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //-----------------------------------------
 if table.Name = 'SG_PCN' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //--------------------------------------------
 if Table.Name = 'SG_UOZ' then begin
   if uoz_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if uoz_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if uoz_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //---------------------------------------------
 if Table.Name = 'SG_AFR' then begin
   if afr_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if afr_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if afr_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
//-------------------------------------------------
  if Table.name = 'SG_FAZA' then begin
   if faza_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis[i]);
   if faza_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis[i]);
   if faza_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //-----------------------------------------------------
 end;
//---------------------------------------------------------------------------
end;

if count = 1023 then begin
Table.ColCount:=33;
Table.RowCount:=33;

for i := 1 to 32 do begin
 table.Cells[i,0]:=IntToStr(FRPMAxis_32[i]);
 //------------------------------------------
  if Table.Name = 'SG_BCN' then begin
   if bcn_data.dad then table.Cells[0,i]:=IntToStr(self.FdadAxis_32[i]);
   if bcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if bcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
  end;
 //-----------------------------------------
 if table.Name = 'SG_PCN' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis_32[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);

 end;
 //--------------------------------------------
  if table.Name = 'SG_COEFF' then begin
   if pcn_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis_32[i]);
   if pcn_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if pcn_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);

 end;
 //--------------------------------------------
 if Table.Name = 'SG_UOZ' then begin
   if uoz_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis_32[i]);
   if uoz_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if uoz_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //---------------------------------------------
 if Table.Name = 'SG_AFR' then begin
   if afr_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis_32[i]);
   if afr_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if afr_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //------------------------------------------
  if Table.Name = 'SG_faza' then begin
   if faza_data.dad then table.Cells[0,i]:=IntToStr(self.FDADAxis_32[i]);
   if faza_data.TPS then table.Cells[0,i]:=IntToStr(self.FThrottleAxis_32[i]);
   if faza_data.BCN then table.Cells[0,i]:=IntToStr(self.FBCNAxis[i]);
 end;
 //---------------------------------------------
end;
end;
if table.Name = 'SG_COEFF' then exit;
 for i := startaddr to ( StartAddr + count ) do   begin

  if count = 1023 then begin
  j:= ( i - StartAddr ) div 32 + 1;
  k := 32 * frac( ( i - StartAddr ) / 32 ) + 1;
  end;

  if count = 255 then begin
  j := ( i - StartAddr )  div 16 + 1;
  k := 16 * frac( ( i - StartAddr ) / 16 ) + 1;
  end;

  if count = 511 then begin
   j:=   ( i - StartAddr ) div 32 + 1;
   k := 32 * frac( ( i - StartAddr ) / 32 ) + 1;
  end;
 // if FFirmwareData[ i ] and $80 = $80 then

 // dat:= FFirmwareData[ i ] - 256 else
 dat:= FFirmwareData[ i ];
if Table.Name = 'SG_OLT' then begin
 case self.Type_Table_ID of
  0:begin
    dat:= FFirmwareData[ i ];

  end;
  1:begin
   //dat:=FFirmwareData[ i ] xor $80;
   if FFirmwareData[ i ] and $80 = $80 then
   Dat:=FFirmwareData[ i ] - 256 else
   Dat:=FFirmwareData[ i ];
  end;
 end;
end;

if table.Name = 'SG_UOZ' then begin
if FFirmwareData[ i ] and $80 = $80  then
dat:= -(256 - FFirmwareData[ i ] );
end;
//------------------------
if table.Name = 'SG_PCN' then begin
 if dat/128 > MAX_PCN then MAX_PCN:=dat/128;
 if dat/128 < min_pcn then min_pcn:=dat/128;
end;
//----------------------------
if table.Name = 'SG_OLT' then begin
 if ((dat + sum )/delitel*mnozitel) > max_table then max_table:=(dat + sum )/delitel*mnozitel;
 if ((dat + sum )/delitel*mnozitel) < min_table then min_table:=((dat + sum )/delitel*mnozitel);
end;
//--------------------------
//Valda:=(dat + sum )/delitel*mnozitel;
  Table.cells[ Round(k), Round(j) ] :=FormatFloat('##0.##',(dat + sum )/delitel*mnozitel);
 end;
if table.Name = 'SG_PCN' then begin
 avg_pcn:=(max_pcn+min_pcn)/2;
end;
if table.Name = 'SG_OLT' then begin
avg_table:=(min_table+max_table)/2;
end;
end;

//������� ���������� �������� �����
function Tfirmware.GetAfrXX(Data: Byte):real;
begin
 result:=(data + 128)*14.7 / 256;
end;
//�������� ��������� �����������, �������� ����� �� ��������� ��� ��������
Function TFirmware.GetQuantValue():integer;
var
  i: integer;
begin
result:=0;
  for i := 0 to Length( FFirmwareData ) - 1 do begin
    if FFirmwareData[ i ] = $90 then begin
      if ( FFirmwareData[ i + 1 ] = $61 ) and
         ( FFirmwareData[ i + 2 ] = $3C ) and
         ( FFirmwareData[ i + 3 ] = $E5 )
      then begin
        if FFirmwareData[ i + 4 ] = $54 then begin
          Result:=30;
        end;

        if FFirmwareData[ i + 4 ] = $55 then begin
          Result:=40;
        end;
      end;
    end;
  end;
end;
//�������� ��� ��������
procedure TFirmware.GetRPMAxis;
var
  i, k, LastValue: integer;
  RPMQuantTable: array of byte;
  RPM: array [1..16] of byte;
  RPM_32:array[1..32] of byte;
  FQuantValue:integer;
  rpmValue: integer;
  // 0x0000613C - ������ ������� ����������� ��������. ����� 256 ��������
begin
//��������� ��������� �����������
FQuantValue:=GetQuantValue;
// ��������� ������� ����������� ��������
  for i := $0000613c to ( $0000613c + 256 ) do begin
    SetLength( RPMQuantTable, Length( RPMQuantTable ) + 1 );
    RPMQuantTable[ i - $0000613c ] := FFirmwareData[ i - 1 ];
  end;

  //  RPM := [ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 ];
  for i := 0 to 15 do begin
    RPM[ i + 1 ] := i * 16;//��� �� ��������� �������� �����, ��� ��
  end;

    for i := 0 to 31 do begin
    RPM_32[ i + 1 ] := i * 8;//��� �� ��������� �������� �����, ��� ��
  end;

  // ------------��������� ��� ��������
  for k := 1 to 16 do begin//��� 16 ����� � 1 �� 16
    LastValue := 0;//�������� 0
    if k > 1 then begin //���� � > 1
      rpmValue := RPM[ k ]; //�� ����������� rpmValue RPM[k](�������� �� 16 �� 240

      repeat//������ ������������ �����
        for i := 0 to Length( RPMQuantTable ) - 1 do begin //������� � ����� ����������� 256 ���
        if RPMQuantTable[ i ] = rpmValue then begin
        LastValue := i - 1;
          if rpmValue = 240 then begin
           break;
          end;

          end;
        end;
        rpmValue := rpmValue + 1;
      until LastValue > 0;//����������� ���� ���������� ����� LastValue ������ > 0

    end else begin//����� ����������� ��������� ���
      for i := 0 to Length( RPMQuantTable ) - 1 do begin
        if RPMQuantTable[ i ] = RPM[ k ] then
          LastValue := i - 1;
      end;
    end;

    FRPMAxis[ k ] := LastValue * FQuantValue;
  end;
//-----------------------------------
  ///////��� 32
    // ��������� ��� ��������
  for k := 1 to 32 do begin//��� 16 ����� � 1 �� 16
    LastValue := 0;//�������� 0
    if k > 1 then begin //���� � > 1
      rpmValue := RPM_32[ k ]; //�� ����������� rpmValue RPM[k](�������� �� 16 �� 240

      repeat//������ ������������ �����
        for i := 0 to Length( RPMQuantTable ) - 1 do begin //������� � ����� ����������� 256 ���
          if RPMQuantTable[ i ] < rpmValue then LastValue := i;
          if RPMQuantTable[ i ] = rpmValue then LastValue := i - 1;
        end;
        inc(rpmValue);// := rpmValue + 1;
      until LastValue > 0;//����������� ���� ���������� ����� LastValue ������ > 0

    end else begin//����� ����������� ��������� ���

      for i := 0 to Length( RPMQuantTable ) - 1 do begin
        if RPMQuantTable[ i ] = RPM_32[ k ] then begin
          LastValue := i - 1;
        end;
      end;
    end;
    FRPMAxis_32[ k ] := LastValue * FQuantValue;
  end;
end;


procedure TFirmware.GetThrottleAxis;
var
  i, k, LastValue: integer;
  TPSQuantTable: array of byte;
  TPS: array [ 1..16 ] of byte;
  tpsValue: byte;
  // 0x00007208 - ������ ������� ����������� ��������. ����� 101 ��������
begin
  // ��������� ������� ����������� ��������
  for i := $00007207 to ( $00007207 + 101 ) do begin
    SetLength( TPSQuantTable, Length( TPSQuantTable ) + 1 );
    TPSQuantTable[ i - $00007207 ] := FFirmwareData[ i ];
  end;

  //TPS := [ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 ];
  for i := 0 to 15 do begin
    TPS[ i + 1 ] := i * 16;
  end;

  // ��������� ��� ��������
  for k := 1 to 16 do begin
    LastValue := 0;
    if k > 1 then begin
      tpsValue := TPS[ k ];

      repeat
        for i := 1 to Length( TPSQuantTable ) - 1 do begin
          if TPSQuantTable[ i ] = tpsValue then begin
            LastValue := i - 1;
          end;
        end;
        tpsValue := tpsValue + 1;
      until LastValue > 0;

    end else begin
      for i := 1 to Length( TPSQuantTable ) - 1 do begin
        if TPSQuantTable[ i ] = TPS[ k ] then begin
          LastValue := i - 1;
        end;
      end;
    end;
    FThrottleAxis[ k ] := LastValue;
  end;
end;

procedure TFirmware.GetThrottleAxis_32;
var
  i, k, LastValue: integer;
  TPSQuantTable: array of byte;
  TPS: array [ 1..32 ] of byte;
  tpsValue: byte;
  // 0x00007208 - ������ ������� ����������� ��������. ����� 101 ��������
begin
  // ��������� ������� ����������� ��������
  for i := $00007207 to ( $00007207 + 101 ) do begin
    SetLength( TPSQuantTable, Length( TPSQuantTable ) + 1 );
    TPSQuantTable[ i - $00007207 ] := FFirmwareData[ i ];
  end;

  //TPS := [ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 ];
  for i := 0 to 31 do begin
    TPS[ i + 1 ] := i * 8;
  end;

  // ��������� ��� ��������
  for k := 1 to 32 do begin
    LastValue := 0;
    if k > 1 then begin
      tpsValue := TPS[ k ];
      repeat
        for i := 0 to Length( TPSQuantTable )-1  do begin
          if TPSQuantTable[ i ] < tpsValue then LastValue := i;
          if TPSQuantTable[ i ] = tpsValue then LastValue := i - 1;

        end;
        inc(tpsValue);// := tpsValue + 1;
      until LastValue > 0;
    end else begin
      for i := 0 to Length( TPSQuantTable )-1 do begin
        if TPSQuantTable[ i ] = TPS[ k ] then begin
          LastValue := i - 1;
        end;
      end;
    end;
    FThrottleAxis_32[ k ] := LastValue;
  end;
end;

procedure Tfirmware.GetDadAxis(startaddrMin1: Word; StartAddrMin2: Word; StartAddrMax: Word;OBR_MUL:integer);
var
  i, DADQuantMIN: integer;
  r,step:real;
  DADQuantMIN1:byte;//�������� ������������ ����������� 1-� ����
  DADQuantMin2: byte;//�������� ������������ ����������� 2-� ����
  DADQuantMAX:byte; //�������� ��������� �����������
  begin
  // ��������� ������� ����������� ��������

  DADQuantMIN1:=FFirmwareData[ startaddrMin1 ];
  DADQuantMin2:=FFirmwareData[ StartAddrMin2 ];
  DADQuantMAX :=FFirmwareData[ StartAddrMax ];
  //f:=(���� + 256 * �����) / 60//���������� ������� ����������� ���
DaDQuantMin:=(DADQuantMIN1 + 256 *DADQuantMin2) div 60;

if DADQuantMAX = 0 then
 r := OBR_MUL
else
 r := OBR_MUL / DADQuantMAX ;
 step:=r / 15/10;

  for i := 1 to 16 do
  FdadAxis[i]:=DadQuantMin+trunc((i-1)*step);
end;

procedure Tfirmware.GetDadAxis_x32(startaddrMin1: Word; StartAddrMin2: Word; StartAddrMax: Word;OBR_MUL:integer);
var
  i, DADQuantMIN: integer;
  r,step:real;
  DADQuantMIN1:byte;//�������� ������������ ����������� 1-� ����
  DADQuantMin2: byte;//�������� ������������ ����������� 2-� ����
  DADQuantMAX:byte; //�������� ��������� �����������
  begin
  // ��������� ������� ����������� ��������
  DADQuantMIN1:=FFirmwareData[ startaddrMin1 ];
  DADQuantMin2:=FFirmwareData[ StartAddrMin2 ];
  DADQuantMAX :=FFirmwareData[ StartAddrMax ];
  //f:=(���� + 256 * �����) / 60//���������� ������� ����������� ���
DaDQuantMin:=(DADQuantMIN1 + 256 *DADQuantMin2) div 60;

if DADQuantMAX = 0 then
 r := OBR_MUL
else
 r := OBR_MUL / DADQuantMAX ;
 step:=r / 31 / 10;
  for i := 1 to 32 do
   FdadAxis_32[i]:=DadQuantMin+trunc((i-1)*step);
end;

procedure tfirmware.GetGBCAxis;
var
  i, GBCQuantMIN: integer;
  r,step:real;
  GBCQuantMIN1:byte;//�������� ������������ ����������� 1-� ����
  GBCQuantMin2: byte;//�������� ������������ ����������� 2-� ����
  GBCQuantMAX:byte; //�������� ��������� �����������
  //GBC: array [ 1..16 ] of byte;//�������� ��� �����������
 // GBCValue: byte;
begin
  GBCQuantMIN1:=FFirmwareData[ $00006064 ];
  GBCQuantMin2:=FFirmwareData[ $00006065 ];
  GBCQuantMAX:=FFirmwareData [ $00006066 ];
  GBCQuantMin:=round((GBCQuantMIN1 + 256 *GBCQuantMin2)/6);//������� ����������� gbc
  if GBCQuantMAX = 0 then
 r := 81900
else
 r := 81900 / GBCQuantMAX ;
 step:=r/15;
  for i := 1 to 16 do
  FBCNAxis[i]:=GBCQuantMin+trunc((i-1)*step);
end;

//���������� swid ��������
 function Tfirmware.ReadSwidFirmware():string;
 var
  i:integer;
  s:integer;
  t,t2:byte;
 begin
 s:=0;
  for i := 0 to $4EF0 do begin
    s:=s+FFirmwareData[i];
  end;
  T2:=lo(s);
  T:=LO(S shr 8);
result:=inttohex(T,2)+IntToHex(T2,2);
 end;

 //���������� ���� �����
 function Tfirmware.ReadBitFirmware(addr: Integer; bit_number: Integer):boolean;
 var
 a,bit:integer;
 begin
 bit:=bit_number;
 a:=0;
  case bit  of
   1:begin
    a:=$1;
   end;
   2:begin
    a:=$2;
   end;
   3:begin
    a:=$4;
   end;
   4:begin
    a:=$8;
   end;
   5:begin
    a:=$10;
   end;
   6:begin
     a:=$20;
   end;
   7:begin
     a:=$40;
   end;
   8:begin
     a:=$80;
   end;
  end;
  if FFirmwareData[addr] and a = a then result:=true
  else result:=false;
 end;
//������� ��������, ����������� ������ � ������� ������ ��������
 function Tfirmware.ParsingFirmware(swid: string):boolean;
 var
 pars:boolean;
 sw_id:integer;
 vibor_sel: Integer;
 begin
 pars:=false;
 //������� ������ � ��������
 Clear_DATA(bcn_data);
 Clear_DATA(pcn_data);
 Clear_DATA(AFR_DATA);
 Clear_Data(uoz_data);
 sw_id:=strtoint('$'+swid);
 vibor_sel:=MessageDlg('�������� J7es ���� ������ 0.4.9?',mtConfirmation, [mbYes, mbNo], 0);
 if vibor_sel = mrYes     then begin
  sw_id:=$1C2E;
  mainform.RadioButton4.Checked:=true;
 end;
  case sw_id of
    //---------
    $2cc4:begin
     NaklonDAD($000060d2,$000060d4);
    end;
  $1709,$FC16:begin
     //trs239
     pcn_data.addr_pcn_tps:=$7CF7;
     pcn_data.addr_pcn_dad:=$736D;
     NaklonDAD($000060d2,$000060d4);
    //-----pcn
    pcn_data.mnozitel:=1;
    if (ReadBitFirmware($5f05,3)) = true then begin //����� ��� ��� �� ��������
    //������ �� ���
     if (ReadBitFirmware($5f05,2)) = true then begin
      pcn_data.dad:=false;
      pcn_data.TPS:=True;
      pcn_data.Addr:=$7CF7;
     end else begin
      pcn_data.dad:=True;
      pcn_data.TPS:=false;
      pcn_data.Addr:=$736D;
      if (ReadBitFirmware($5f04,7)) = true then begin//---�������� ��� �� 32
      pcn_data.load_count:=32 ;
      pcn_data.RPM_count:=32;
      pcn_data.�ount:=1023;
     end else begin
      pcn_data.load_count:=16;
      pcn_data.RPM_count:=16;
      pcn_data.�ount:=255;
     end;
     end;

    end else begin//---����� ��� ���� ����������
     pcn_data.Addr:=$7CF7;
     pcn_data.TPS:=True;
     pcn_data.dad:=false;

     if (ReadBitFirmware($5f04,2)) = true then begin
      pcn_data.RPM_count:=32;
      pcn_data.load_count:=32;
      pcn_data.�ount:=1023;
     end else begin
      pcn_data.RPM_count:=16;
      pcn_data.load_count:=16;
      pcn_data.�ount:=255;
     end;

    end;
    //------pcn

    //-----BCN
    if (ReadBitFirmware($5f04,4)) = true then begin
    bcn_data.Addr:=$726D;
    bcn_data.dad:=true;
    bcn_data.TPS:=false;
    bcn_data.mnozitel:=16;
    end else begin
    bcn_data.Addr:=$75EF;
    bcn_data.TPS:=true;
    bcn_data.dad:=false;
    bcn_data.mnozitel:=8;
    end;
    bcn_data.�ount:=255;
    bcn_data.RPM_count:=16;
    bcn_data.load_count:=16;
    //----end  BCN

    //------UOZ
    if (ReadBitFirmware($5f04,6)) = true then begin
      //uoz dad
     uoz_data.Addr:= $852F;
     uoz_data.dad:=True;
     uoz_data.TPS:=false;
    end else begin
      //uoz TPS
     uoz_data.Addr:= $6DC8;
     uoz_data.dad:=false;
     uoz_data.TPS:=true;
    end;
    uoz_data.load_count:=16;
    uoz_data.RPM_count:=16;
    uoz_data.�ount:=255;
    uoz_data.mnozitel:=1;
    //----END UOZ
    ///---------afr
    if (ReadBitFirmware($5f04,3)) = true then begin
    //����� �� ��������
     afr_data.Addr:=$76EF;
     afr_data.dad:=true;
     afr_data.load_count:=16;
     afr_data.TPS:=false;
     afr_data.RPM_count:=16;
     afr_data.BCN:=false;
     afr_data.�ount:=255;
     afr_data.mnozitel:=1;
    end else begin
      //����� �� ��������
     afr_data.Addr:=$6953;
     afr_data.dad:=false;
     afr_data.load_count:=16;
     afr_data.TPS:=true;
     afr_data.RPM_count:=16;
     afr_data.BCN:=false;
     afr_data.�ount:=255;
     afr_data.mnozitel:=1;
    end;
    //-----end afr
    pars:=True;
   end;//the end trs 239
   $1849:begin
    pars:=True;
    NaklonDAD($000060d2,$000060d4);
//--- BCN
    if (ReadBitFirmware($5f04,4)) = true then begin
    bcn_data.Addr:=$726D;
    bcn_data.dad:=true;
    bcn_data.TPS:=false;
    bcn_data.mnozitel:=16;
    end else begin
    bcn_data.Addr:=$75EF;
    bcn_data.TPS:=true;
    bcn_data.dad:=false;
    bcn_data.mnozitel:=8;
    end;
    bcn_data.�ount:=255;
    bcn_data.RPM_count:=16;
    bcn_data.load_count:=16;
//--------------------------------------------------------------------------
//---- PCN
if (ReadBitFirmware($5f04,2)) then begin
pcn_data.addr_pcn_tps:=$5800;
pcn_data.addr_pcn_dad:=$5A00;
pcn_data.RPM_count:=32;
pcn_data.load_count:=16;
end else begin
pcn_data.addr_pcn_tps:=$7CF7;
pcn_data.addr_pcn_dad:=$736d;
pcn_data.RPM_count:=16;
pcn_data.load_count:=16;
end;
pcn_data.�ount:=pcn_data.RPM_count*pcn_data.load_count - 1;
pcn_data.mnozitel:=1;
if (ReadBitFirmware($5f05,3)) then begin
 pcn_data.TPS:=False;
 pcn_data.dad:=true;
 pcn_data.BCN:=False;
 if (ReadBitFirmware($5f04,2)) then pcn_data.Addr:=$5A00 else  pcn_data.Addr:=$736d;
 if (ReadBitFirmware($5f05,2)) then begin
 pcn_data.TPS:=false;
 pcn_data.dad:=false;
 pcn_data.BCN:=true;
 end;
end else begin
 pcn_data.TPS:=true;
 pcn_data.dad:=false;
 pcn_data.BCN:=False;
 if (ReadBitFirmware($5f04,2)) then pcn_data.Addr:=$5800 else  pcn_data.Addr:=$7cf7;
end;
//--------------------------------------------------------------------------
//---- UOZ
 uoz_data.load_count:=16;
 uoz_data.RPM_count:=16;
 uoz_data.�ount:=255;
 uoz_data.mnozitel:=1;
if (ReadBitFirmware($5f04,6)) then begin
 uoz_data.Addr:=$852F;
 uoz_data.TPS:=False;
 uoz_data.BCN:=False;
 uoz_data.dad:=true;
 end else begin
  uoz_data.Addr:=$6DC8;
  uoz_data.TPS:=true;
  uoz_data.BCN:=False;
  uoz_data.dad:=false;
 end;
//--------------------------------------------------------------------------
    if (ReadBitFirmware($5f04,3)) = true then begin
    //����� �� ��������
     afr_data.Addr:=$76EF;
     afr_data.dad:=true;
     afr_data.load_count:=16;
     afr_data.TPS:=false;
     afr_data.RPM_count:=16;
     afr_data.BCN:=false;
     afr_data.�ount:=255;
     afr_data.mnozitel:=1;
    end else begin
      //����� �� ��������
     afr_data.Addr:=$6953;
     afr_data.dad:=false;
     afr_data.load_count:=16;
     afr_data.TPS:=true;
     afr_data.RPM_count:=16;
     afr_data.BCN:=false;
     afr_data.�ount:=255;
     afr_data.mnozitel:=1;
    end;
   end;
//---------------------- J5LS -----------------------------------------
  $EC56,$FB99:BEGIN
     //J5LS
     pcn_data.addr_pcn_tps:=$7CF7;
     pcn_data.addr_pcn_dad:=$8E2A;
     NaklonDAD($000060d2,$000060d4);
     pars:=True;
    //-----pcn
    pcn_data.mnozitel:=1;
    if (ReadBitFirmware($5f05,3)) = true then begin //����� ��� ��� �� ��������
    //������ �� ���
     if (ReadBitFirmware($5f05,2)) = true then begin
      pcn_data.dad:=false;
      pcn_data.TPS:=True;
      pcn_data.Addr:=$7CF7;
      pcn_data.load_count:=16;
      pcn_data.RPM_count:=16;
      pcn_data.�ount:=255;
     end else begin
      pcn_data.dad:=True;
      pcn_data.TPS:=false;
      pcn_data.Addr:=$8E2A;
      pcn_data.load_count:=16;
      pcn_data.RPM_count:=16;
      pcn_data.�ount:=255;
     end;

    end else begin//---����� ��� ���� ����������
     pcn_data.Addr:=$7CF7;
     pcn_data.TPS:=True;
     pcn_data.dad:=false;
     pcn_data.RPM_count:=16;
     pcn_data.load_count:=16;
     pcn_data.�ount:=255;
    end;
    //-----BCN
    bcn_data.Addr:=$75EF;
    bcn_data.TPS:=true;
    bcn_data.dad:=false;
    bcn_data.mnozitel:=8;
    bcn_data.�ount:=255;
    bcn_data.RPM_count:=16;
    bcn_data.load_count:=16;
       //------UOZ
    if (ReadBitFirmware($5f07,6)) = true then begin
      //uoz dad, afr dad
     uoz_data.Addr:= $852F;
     uoz_data.dad:=True;
     uoz_data.TPS:=false;
     afr_data.addr:=$76EF;
     afr_data.dad:=true;
     afr_data.TPS:=False;
     afr_data.BCN:=false;
    end else begin
      //uoz TPS
    uoz_data.Addr:= $6DC8;
    uoz_data.dad:=false;
    uoz_data.TPS:=true;
    afr_data.addr:=$6953;
    afr_data.dad:=false;
    afr_data.TPS:=true;
    afr_data.BCN:=false;
    end;
    uoz_data.load_count:=16;
    uoz_data.RPM_count:=16;
    uoz_data.�ount:=255;
    uoz_data.mnozitel:=1;
    afr_data.load_count:=16;
    afr_data.RPM_count:=16;
    afr_data.�ount:=255;
    afr_data.mnozitel:=1;
    //----END UOZ
  END;
    //--------
    $848C,$FB9C, $3B00,$D0F1,$D107,$D20F,$F6FC,$1C2E,$1C2F,$28A7,$28B8, $384A,$140F,$391F:begin
     //j7es

     pcn_data.addr_pcn_tps:=$7CF7;
     pcn_data.addr_pcn_dad:=$9294;
     pars:=True;
     NaklonDAD_J7ES($00006098,$0000609A);
    //faza
    faza_data.ID_CTE:='9DE43474';
    faza_data.addr:=$64D3;
    faza_data.DAD:=false;
    faza_data.TPS:=false;
    faza_data.BCN:=true;
    if (ReadBitFirmware($5f01,2)) = true then begin
    faza_data.ID_CTE:='64D35908';
    faza_data.BCN:=false;
    faza_data.DAD:=true;
    end;
    faza_data.�ount:=255;
    faza_data.mnozitel:=6;
    faza_data.load_count:=16;
    faza_data.RPM_count:=16;
     //���

    bcn_data.ID_CTE:='279E7F4E';
    bcn_data.addr:=$75EF;
    bcn_data.�ount:=255;
    bcn_data.DAD:=false;
    bcn_data.TPS:=true;

    if (sw_id = $1C2E) or (sw_id = $848C)  then   begin
     if (ReadBitFirmware($5f02,6)) = true then begin
      bcn_data.ID_CTE:='279E7F4F';
      bcn_data.addr:=$99A7;
      bcn_data.DAD:=true;
      bcn_data.TPS:=false;
     end;
    end;

    bcn_data.BCN:=false;
    bcn_data.mnozitel:=8;
    bcn_data.load_count:=16;
    bcn_data.RPM_count:=16;
     //���
     //�������� ����� ���
     if (ReadBitFirmware($5f02,1)) = true then begin
         pcn_data.ID_CTE:='7BF20B0D';
         pcn_data.Addr:=$9294;
         pcn_data.dad:=true;
       if (ReadBitFirmware($5f02,2)) = true then begin
         //����� �� ���
        pcn_data.BCN:=true;
       end;
       //�������� ����� ��� �� 32 ���
       if ReadBitFirmware($5f02,5) = true then begin
        pcn_data.�ount:=1023;
        pcn_data.RPM_count:=32;
        pcn_data.load_count:=32;
       end
       else begin
        if ReadBitFirmware($5f02,4) = true then begin
         pcn_data.Addr:=$7CF7;
         pcn_data.dad:=FALSE;
         pcn_data.load_count:=16;
         pcn_data.TPS:=true;
         pcn_data.RPM_count:=32;
         pcn_data.BCN:=false;
         pcn_data.�ount:=511;
         pcn_data.mnozitel:=1;
        end else begin
        pcn_data.RPM_count:=16;
        pcn_data.load_count:=16;
        pcn_data.�ount:=255;
        end;
       end;

     end else begin
     //���� �� ����� ���� ���
     pcn_data.ID_CTE:='454C2B1C';
     pcn_data.Addr:=$7cf7;
     pcn_data.TPS:=true;
     pcn_data.load_count:=16;
     if ReadBitFirmware($5f02,4) = true then begin
     pcn_data.RPM_count:=32;
     pcn_data.�ount:=511;
     end
     else begin
     pcn_data.RPM_count:=16;
     pcn_data.�ount:=255;
     end;
     end;
     //afr
   afr_data.load_count:=16;
   afr_data.RPM_count:=16;
   afr_data.�ount:=255;
   uoz_data.load_count:=16;
   uoz_data.RPM_count:=16;
   uoz_data.�ount:=255;
   if ReadBitFirmware($5f01,2) = true then begin
    afr_data.ID_CTE:='8DAE3736';
    afr_data.Addr:=$83BA;
    afr_data.dad:=true;
    afr_data.TPS:=false;
    afr_data.BCN:=false;

    uoz_data.ID_CTE:='9F8A59E4';
    uoz_data.Addr:=$6AC8;
    uoz_data.dad:=true;
    uoz_data.TPS:=false;
    uoz_data.BCN:=false;
   end else begin
     //�������� ������ �� ���
   if ReadBitFirmware($5f01,1) = true then begin
    uoz_data.ID_CTE:='6AC83F73';
    uoz_data.Addr:=$6DC8;
    uoz_data.TPS:=false;
    uoz_data.dad:=false;
    uoz_data.BCN:=true;

    afr_data.ID_CTE:='83BA87FF';
    afr_data.Addr:=$6953;
    afr_data.TPS:=false;
    afr_data.dad:=false;
    afr_data.BCN:=true;
    end else begin
    uoz_data.ID_CTE:='3A4D9EF3';
    uoz_data.Addr:=$6DC8;
    uoz_data.TPS:=true;
    uoz_data.dad:=false;
    uoz_data.BCN:=false;

    afr_data.ID_CTE:='FF654C89';
    afr_data.Addr:=$6953;
    afr_data.TPS:=true;
    afr_data.dad:=false;
    afr_data.BCN:=false;
     end;
   end;
    end;
  //end J7ES

  end;
  exit(pars);
 end;
 //������� ������ � �������
 procedure Tfirmware.Clear_DATA(var data : Data_Table);
 begin
  with data do
  begin
    ID_CTE:='';//id ���������� ��� ������� � CTP
    Addr:=0;//����� �������
    dad:=false;//������� �� ���
    load_count:=16;//���������� ����� �� ��� ��������
    TPS:=false;//������� �� ��������
    RPM_count:=16;//���������� ����� �� ��� ��������
    BCN:=false;//������� �� ���
    �ount:=256;//������ �������
    mnozitel:=1;//���������
  end;
 end;
//������ ��������� �������� ��
procedure Tfirmware.WriteDataPcn(Acol: Integer; Arow: Integer;summa:boolean);
var
S:integer;
begin
 if pcn_data.RPM_count = 16 then begin
   S:=((Arow-1)*16) + Acol - 1;
   if summa then
   FFirmwareData[pcn_data.Addr + S]:=FFirmwareData[pcn_data.Addr + S]+1
   else
   FFirmwareData[pcn_data.Addr + S]:=FFirmwareData[pcn_data.Addr + S]-1;
 end;
  if pcn_data.RPM_count = 32 then begin
   S:=((Arow-1)*32) + Acol - 1;
   if summa then
   FFirmwareData[pcn_data.Addr + S]:=FFirmwareData[pcn_data.Addr + S]+1
   else
   FFirmwareData[pcn_data.Addr + S]:=FFirmwareData[pcn_data.Addr + S]-1;
 end;
end;
//������ ��������� ���
procedure Tfirmware.WriteDataUOZ(Acol: Integer; Arow: Integer;summa:boolean);
var
S:integer;
begin
 if uoz_data.RPM_count = 16 then begin
   S:=((Arow-1)*16) + Acol - 1;
   if summa then
   FFirmwareData[uoz_data.Addr + S]:=FFirmwareData[uoz_data.Addr + S]+1
   else
   FFirmwareData[uoz_data.Addr + S]:=FFirmwareData[uoz_data.Addr + S]-1;
 end;
  if uoz_data.RPM_count = 32 then begin
   S:=((Arow-1)*32) + Acol - 1;
   if summa then
   FFirmwareData[uoz_data.Addr + S]:=FFirmwareData[uoz_data.Addr + S]+1
   else
   FFirmwareData[uoz_data.Addr + S]:=FFirmwareData[uoz_data.Addr + S]-1;
 end;
end;
//������ ��������� AFR
procedure Tfirmware.WriteDataAFR(Acol: Integer; Arow: Integer;summa:boolean);
var
S:integer;
begin
 if AFR_data.RPM_count = 16 then begin
   S:=((Arow-1)*16) + Acol - 1;
   if summa then
   FFirmwareData[AFR_data.Addr + S]:=FFirmwareData[AFR_data.Addr + S]+1
   else
   FFirmwareData[AFR_data.Addr + S]:=FFirmwareData[AFR_data.Addr + S]-1;
 end;
  if AFR_data.RPM_count = 32 then begin
   S:=((Arow-1)*32) + Acol - 1;
   if summa then
   FFirmwareData[AFR_data.Addr + S]:=FFirmwareData[afr_data.Addr + S]+1
   else
   FFirmwareData[AFR_data.Addr + S]:=FFirmwareData[afr_data.Addr + S]-1;
 end;
end;

procedure Tfirmware.InterpolateTablePcn;
var
i,t:integer;
NomRt,RT_1,RT_3:integer;//����� �������� �����
begin
//-----���������� �� ��������
 for i := 1 to pcn_data.load_count - 1 do
   for t := 1 to pcn_data.RPM_count - 1 do begin
    NomRt:=(I-1)*pcn_data.RPM_count + T;
    if (T > 1) and (T < pcn_data.RPM_count) then
    FFirmwareData[pcn_data.Addr + NomRt - 1] :=round((FFirmwareData[pcn_data.Addr + NomRt - 2]
    +FFirmwareData[pcn_data.Addr + NomRt-1] +FFirmwareData[pcn_data.Addr + NomRt])/3);
   end;
///----���������� �� ��������
  for i := 1 to pcn_data.RPM_count - 1 do
   for t := 1 to pcn_data.load_count - 1 do begin
    NomRt:=(T-1)*pcn_data.RPM_count + I;
    RT_1:= (T - 2)*pcn_data.RPM_count + I;
    RT_3:=(T)*pcn_data.RPM_count + I;
    if (T - 1 > 0) and ( T <= pcn_data.load_count )  then
    FFirmwareData[pcn_data.Addr + NomRt - 1] :=round((FFirmwareData[pcn_data.Addr + RT_1 - 1]
    +FFirmwareData[pcn_data.Addr + NomRt-1] +FFirmwareData[pcn_data.Addr + RT_3 - 1])/3);
  end;
end;
procedure Tfirmware.InterpolateTableBcn;
var
i,t:integer;
NomRt,RT_1,RT_3:integer;//����� �������� �����
begin
//-----���������� �� ��������
 for i := 1 to bcn_data.load_count - 1 do
   for t := 1 to bcn_data.RPM_count - 1 do begin
    NomRt:=(I-1)*bcn_data.RPM_count + T;
    if (T > 1) and (T < bcn_data.RPM_count) then
    FFirmwareData[bcn_data.Addr + NomRt - 1] :=round((FFirmwareData[bcn_data.Addr + NomRt - 2]
    +FFirmwareData[bcn_data.Addr + NomRt-1] +FFirmwareData[bcn_data.Addr + NomRt])/3);
   end;
///----���������� �� ��������
  for i := 1 to bcn_data.RPM_count - 1 do
   for t := 1 to bcn_data.load_count - 1 do begin
    NomRt:=(T-1)*bcn_data.RPM_count + I;
    RT_1:= (T - 2)*bcn_data.RPM_count + I;
    RT_3:=(T)*bcn_data.RPM_count + I;
    if (T - 1 > 0) and ( T <= bcn_data.load_count )  then
    FFirmwareData[bcn_data.Addr + NomRt - 1] :=round((FFirmwareData[bcn_data.Addr + RT_1 - 1]
    +FFirmwareData[bcn_data.Addr + NomRt-1] +FFirmwareData[bcn_data.Addr + RT_3 - 1])/3);
  end;
end;
procedure Tfirmware.GeneratorUoz(flag_afr:boolean);
var
i,t:integer;//������� ������
X:real;//��� �� ������������ ����� ��������
PercentLoad:real;//������� ��������
NewUOZ:real;//����� ���
MaxLoad:integer;//������������ �������� �� ��� ����������
Load:integer;//������� ��������
adr:integer;
afr:real;//������ �����
afr_co:real;//��������� ���� �� ������� �����
begin
//
Load:=0;
MaxLoad:=0;
if uoz_data.dad then  MaxLoad:=self.FDADAxis[16];
if uoz_data.BCN then  MaxLoad:=self.FBCNAxis[16];
 for i := 1 to 16 do
  for t := 1 to 15 do begin
  if uoz_data.dad then  Load:=self.FDADAxis[T];
  if uoz_data.BCN then  Load:=self.FBCNAxis[T];
  //--- ��� ������� ��� �� ������� �� ���������� ---
  if uoz_data.TPS then begin
    MaxLoad:= FFirmwareData[bcn_data.Addr+240+i-1];
    load:= FFirmwareData[bcn_data.Addr+(t-1)*16+i-1];
  end;
  //--- afr 0.8 = -20% afr 1 = 0% afr 1.2 = +20%
  //--- ������� ������� ����� �� ��� ----------
  //-- 1. �������� ������ ����� �� ������� (data + 128)*14.7 / 256;
  // --- (y1 - y0)/(y2 - y0) = (x1 - x0)/(x2 - x0)
  //-- x1 = (((y1 - y0)/(y2 - y0)) * (x2 - x0)) + x0

  //----- x1 = x0 + (y1 - y0)/(y2 - y0)*(x2-x0)
  // --- x0 = -20%, x2 = 20%, y0 = 11.7, y2 = 17.64
  afr:=(FFirmwareData[ afr_data.Addr+(t-1)*16+i - 1] + 128)* 14.7 / 256 ;
 if ( afr > 11.7 ) and ( afr < 17.7 ) then
  afr_co:=((( afr - 11.7 ) / 6 ) * 0.4) + 0.8;
 if afr > 17.6 then  afr_co:=1.2;
 if afr < 11.7 then  afr_co:=0.8;


  //---------------------------------------------------
  PercentLoad:=100 - (load*100/MaxLoad);//������� ����������(�� ����� ��������� �������� ���)
  X:=self.FFirmwareData[uoz_data.Addr+240+i-1]/2;//��� �����������
  if flag_afr then NewUOZ:=X + ( X * PercentLoad / 100 * afr_co)
  else
  NewUOZ:=X + ( X * PercentLoad / 100 );

  if NewUOZ > 60 then NewUOZ:=60;
  adr:=((t-1)*16) + i;
   FFirmwareData[uoz_data.Addr+adr-1]:=round(NewUOZ*2);
  end;
end;
//-------------------
function tfirmware.ReadvalueData_1D(Type_ID: Integer; ADRR_CALIB: Integer; OBR_MULT: Real; delitel: Real; MNOZITEL: Real; SMESHENIE: Real;smeshenie_2DATA:real):real;
var
dat:integer;
begin
//----- Type_ID - ��� ���������
//----------(�������� ����� / data / delitel ��� ���� * ���)+��������
result:=0;
case Type_ID of
  0:begin
    if OBR_MULT<>0 then
    result:=OBR_MULT/(FFirmwareData[ADRR_CALIB]+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=(FFirmwareData[ADRR_CALIB]+smeshenie_2DATA) /delitel*mnozitel - SMESHENIE ;
  end;
  //----------------------
  1:begin
  if FFirmwareData[ADRR_CALIB] and $80 = $80 then
     dat:=FFirmwareData[ADRR_CALIB] and $7F - 128 else
     dat:=FFirmwareData[ADRR_CALIB];
  if OBR_MULT<>0 then
    result:=OBR_MULT/(dat+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=(dat+smeshenie_2DATA) /delitel*mnozitel - SMESHENIE ;
  end;
  //---------------------
  2:begin
    if OBR_MULT<>0 then
    result:=OBR_MULT/((FFirmwareData[ADRR_CALIB]+256*FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=((FFirmwareData[ADRR_CALIB]+256*FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE ;
  end;
  //--------------------
  3:begin
  if OBR_MULT<>0 then
    result:=OBR_MULT/((FFirmwareData[ADRR_CALIB]+256*FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=((FFirmwareData[ADRR_CALIB]+256*FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE ;
  end;
  //---------------------
  4:begin
   if OBR_MULT<>0 then
    result:=OBR_MULT/((FFirmwareData[ADRR_CALIB]*256+FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=((FFirmwareData[ADRR_CALIB]*256+FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE ;
  end;
  //------------------------
  5:begin
  if OBR_MULT<>0 then
    result:=OBR_MULT/((FFirmwareData[ADRR_CALIB]*256+FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE else
    result:=((FFirmwareData[ADRR_CALIB]*256+FFirmwareData[ADRR_CALIB+1])+smeshenie_2DATA) /delitel*mnozitel + SMESHENIE ;
  end;
  //-*------------------
end;
end;
//---------------------------------- ��������� ������ �������� � �������� -----------------------------------------------------------------------------------
procedure Tfirmware.WriteValueData_1D(Type_ID: Integer; ADRR_CALIB: Integer; OBR_MULT: Real; delitel: Real; MNOZITEL: Real; SMESHENIE: Real; smeshenie_2DATA: Real; Data_VAL: Double);
 var
  dat:int64;
begin
case Type_ID of
//-----------------------------
 0:begin
  if OBR_MULT <> 0 then
   FFirmwareData[ADRR_CALIB]:=round(OBR_MULT / ( (Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA ) )
  else
   FFirmwareData[ADRR_CALIB]:=round((Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA );
 end;
 //-----------------------------
 1:begin
  if OBR_MULT <> 0 then
   FFirmwareData[ADRR_CALIB]:=round(OBR_MULT / ( (Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA ) )
  else
   FFirmwareData[ADRR_CALIB]:=round((Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA );
 end;
 //-------------------------------
 2:begin
  if OBR_MULT <> 0 then
   Dat:=round(OBR_MULT / ( (Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA ) )
  else
   Dat:=round((Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA );
   FFirmwareData[ADRR_CALIB+1]:=dat div 256;
   FFirmwareData[ADRR_CALIB]:=DAT - FFirmwareData[ADRR_CALIB+1];
 end;
 //---------------------------------
 3:begin
  if OBR_MULT <> 0 then
   Dat:=round(OBR_MULT / ( (Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA ) )
  else
   Dat:=round((Data_VAL - SMESHENIE) / MNOZITEL * delitel - smeshenie_2DATA );
   FFirmwareData[ADRR_CALIB+1]:=dat div 256;
   FFirmwareData[ADRR_CALIB]:=DAT - FFirmwareData[ADRR_CALIB+1];
 end;
 //---------------------------------
 4:begin

 end;
 //-----------------------------------
 5:begin

 end;
 //---------------------------------
end;
end;
function Tfirmware.ReadNameOC_X(name: string; count_ToX: Integer; number_TOX: Integer):string;
var
//I:integer;
TypeCalib:integer;
addr,addr2:integer;
QuantValue:integer;
begin
//--------
TypeCalib:=StrToInt(name[2]+name[3]+name[4]);

//--------
case TypeCalib of
 1:begin
  addr:=StrToInt('$'+name[6]+name[7]+name[8]+name[9]);
  QuantValue:=StrToInt(name[11]+name[12]);
  result:=inttostr(ReadID_1(addr,count_ToX,number_TOX,QuantValue));
 end;
 2:begin

 end;
 3:begin
 addr:=StrToInt('$'+name[6]+name[7]+name[8]+name[9]);
 addr2:=StrToInt('$'+name[11]+name[12]+name[13]+name[14]);
 result:=IntToStr(ReadID_3(addr,addr2,count_ToX,number_TOX));
 end;
 4:BEGIN

 END;
 5:BEGIN

 END;
 6:BEGIN
  addr:=StrToInt('$'+name[6]+name[7]+name[8]+name[9]);
  result:=inttostr(ReadID_6(addr,count_ToX,number_TOX));
 END;
end;
//----------
end;
//-----------������� �� ID=1
function Tfirmware.ReadID_1(addr:integer;count_TOX:integer;NumberX:integer;FQuantValue:integer):integer;
var
I,k,LastValue,rpmValue:integer;
RPMQuantTable:array of byte;
RPM:array of byte;
mnoz:integer;
ArrayRPM:array of integer;
begin
//---- ��������� ������� ����������� ��������
  for i := addr to ( addr + 256 ) do begin
    SetLength( RPMQuantTable, Length( RPMQuantTable ) + 1 );
    RPMQuantTable[ i - addr ] := FFirmwareData[ i - 1 ];
  end;
  mnoz:=0;
  result:=0;
//-----������� ��������   [ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 ];
if count_tox = 16 then mnoz:=16;
if count_tox = 32 then mnoz:=8;
for i := 0 to count_TOX - 1 do begin
 setlength(RPM,i+1);
 RPM[i]:=i*mnoz;
end;
//
  // ��������� ��� ��������
  ///////��� 32
    // ��������� ��� ��������
  for k := 1 to length(rpm) do begin//��� 16 ����� � 1 �� 16
    LastValue := 0;//�������� 0
    if k > 1 then begin //���� � > 1
      rpmValue := RPM[ k - 1 ]; //�� ����������� rpmValue RPM[k](�������� �� 16 �� 240
      repeat//������ ������������ �����
        for i := 1 to Length( RPMQuantTable ) - 1 do begin //������� � ����� ����������� 256 ���
          if RPMQuantTable[ i ] = rpmValue then begin
            LastValue := i - 1;
          end;
        end;
        rpmValue := rpmValue + 1;
        if rpmValue > 255 then LastValue:= 255;


      until LastValue > 0;//����������� ���� ���������� ����� LastValue ������ > 0

    end else begin//����� ����������� ��������� ���
      for i := 1 to Length( RPMQuantTable ) - 1 do begin
        if RPMQuantTable[ i ] = RPM[ k - 1 ] then begin
          LastValue := i - 1;
        end;
      end;
    end;
    setlength(ArrayRPM,length(ArrayRPM)+1);
    ArrayRPM[k-1]:=LastValue * FQuantValue;
  end;
    result:=ArrayRPM[ NumberX ];

end;
function Tfirmware.ReadID_6(addr: Integer; count_tox: integer; number: Integer):integer;
var
  i, k, LastValue: integer;
  TPSQuantTable: array of byte;
  TPS: array  of byte;
  tpsValue: byte;
  FThrottle:array of integer;
  // 0x00007208 - ������ ������� ����������� ��������. ����� 101 ��������
begin
  // ��������� ������� ����������� ��������
  for i := addr to ( addr + 101 ) do begin
    SetLength( TPSQuantTable, Length( TPSQuantTable ) + 1 );
    TPSQuantTable[ i - addr ] := FFirmwareData[ i - 1 ];
  end;

  //TPS := [ 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 ];
  k:=0;
  if count_tox = 32 then k:=8;
  if count_tox = 16 then k:=16;

  for i := 0 to count_tox-1 do begin
  setlength(tps,length(tps)+1);
    TPS[ i  ] := i * k;
  end;

  // ��������� ��� ��������
  for k := 1 to count_tox do begin
    LastValue := 0;
    if k > 1 then begin
      tpsValue := TPS[ k - 1 ];

      repeat
        for i := 1 to Length( TPSQuantTable ) - 1 do begin
          if TPSQuantTable[ i ] = tpsValue then begin
            LastValue := i - 1;
          end;
        end;
        tpsValue := tpsValue + 1;
      until LastValue > 0;

    end else begin
      for i := 1 to Length( TPSQuantTable ) - 1 do begin
        if TPSQuantTable[ i ] = TPS[ k - 1] then begin
          LastValue := i - 1;
        end;
      end;
    end;
    setlength(FThrottle,length(FThrottle)+1);
    FThrottle[ k - 1 ] := LastValue;

  end;
  result:=fthrottle[number];
end;
function tfirmware.ReadID_3(addr1: Integer; addr2: Integer; count_tox: Integer; number: Integer):integer;
var
  i,// k, //LastValue,
  GBCQuantMIN: integer;
  r,step:real;
  GBCQuantMIN1:byte;//�������� ������������ ����������� 1-� ����
  GBCQuantMin2: byte;//�������� ������������ ����������� 2-� ����
  GBCQuantMAX:byte; //�������� ��������� �����������
 // GBC: array of byte;//�������� ��� �����������
 // GBCValue: byte;
  FBCN:array of integer;
  begin
  GBCQuantMIN1:=FFirmwareData[ addr1 ];
  GBCQuantMin2:=FFirmwareData[ addr1+1 ];
  GBCQuantMAX:=FFirmwareData [ addr2 ];
  GBCQuantMin:=round((GBCQuantMIN1 + 256 *GBCQuantMin2)/6);//������� ����������� gbc
  if GBCQuantMAX = 0 then
 r := 81900
else
 r := 81900 / GBCQuantMAX ;
 step:=r/(count_tox-1);
  for i := 1 to count_tox do begin
  setlength(FBCN,length(FBCN)+1);
  FBCN[i-1]:=GBCQuantMin+trunc((i-1)*step);
  end;
  result:=FBCN [number];
end;

Function Tfirmware.InterpolateData(data1: Integer; Data2: Integer; Coeff: Real):INTEGER;
begin
 result:=round((data2 - data1) * coeff + data1);
end;
end.
