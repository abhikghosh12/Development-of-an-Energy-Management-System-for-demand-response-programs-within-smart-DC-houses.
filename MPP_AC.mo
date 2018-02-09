// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
model MPP_AC "Maximum power point tracker customised for AC and DC system"
	GreenBuilding.Interfaces.Electrical.ThreePhase Grid3 "3-phase connection to Grid" annotation(Placement(
		transformation(extent={{240,-5},{260,15}}),
		iconTransformation(extent={{190,90},{210,110}})));
	GreenBuilding.Interfaces.Electrical.DC PVDC "DC connection to PV system" annotation(Placement(
		transformation(extent={{45,-25},{65,-5}}),
		iconTransformation(extent={{-210,-10},{-190,10}})));
	input Modelica.Blocks.Interfaces.RealInput MPP(
		quantity="Electricity.Voltage",
		displayUnit="V") "Demanded control voltage of photovoltaics module" annotation(
		Placement(
			transformation(
				origin={120,60},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={0,200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Max-Power-Point-Voltage",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	GreenBuilding.Utilities.Electrical.B6Converter B6Converter(eta=etaConverter) if PVPhase==3 "B6 Converter" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="Max-Power-Point-Voltage",
			tab="Results"));
	GreenBuilding.Utilities.Electrical.B2Converter B2Converter(eta=etaConverter) if PVPhase==1 "B2 Converter" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="Max-Power-Point-Voltage",
			tab="Results"));
	Real PAC(
		quantity="Basics.Power",
		displayUnit="kW") "AC effective power output" annotation(Dialog(
		group="Power",
		tab="Results",
		__iti_showAs=ShowAs.Result));
	Real PACnet(
		quantity="Basics.Power",
		displayUnit="kW") "AC effective power output" annotation(Dialog(
		group="Power",
		tab="Results",
		__iti_showAs=ShowAs.Result));
	protected
		Real QAC(
			quantity="Basics.Power",
			displayUnit="kVA") "AC reactive power output" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	public
		parameter Real alpha=0.97222222222222221 "duty cycle" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		Real PDC(
			quantity="Basics.Power",
			displayUnit="kW") "DC power input " annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		Real PDCoutput(
			quantity="Basics.Power",
			displayUnit="kW") "DC power output " annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		parameter Real etaConverter=0.95 "Efficiency of PV-Converter" annotation(Dialog(
			group="Efficiency",
			tab="Parameters"));
		parameter Integer PVPhase=1 "Number of phases PVConverter is connected to" annotation(Dialog(
			group="Grid Connection",
			tab="Parameters"));
	equation
			B6Converter.Connected=true;
			B6Converter.alphaRef=acos(min(max(MPP/(2.34*B6Converter.VGrid),-1),1));		
		connect(B6Converter.DC,PVDC) annotation(Line(points={{10,0},{15,0},{50,0},{50,-15},{55,-15}}));
		connect(B6Converter.Grid3,Grid3) annotation(Line(points={{-10,0},{-15,0},{-15,10},{245,10},{245,5},{250,
		5}}));
		PDC=PVDC.I*PVDC.V;
		PAC=Grid3.Veff3[1]*Grid3.Ieff3[1]*cos(Grid3.PhiPhase3[1])+Grid3.Veff3[2]*Grid3.Ieff3[2]*cos(Grid3.PhiPhase3[2])+Grid3.Veff3[3]*Grid3.Ieff3[3]*cos(Grid3.PhiPhase3[3]);
		QAC=Grid3.Veff3[1]*Grid3.Ieff3[1]*sin(Grid3.PhiPhase3[1])+Grid3.Veff3[2]*Grid3.Ieff3[2]*sin(Grid3.PhiPhase3[2])+Grid3.Veff3[3]*Grid3.Ieff3[3]*sin(Grid3.PhiPhase3[3]);
	annotation(
		__iti_viewinfo[0](
			simViewInfos[0](
				runtimeClass="CSimView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ModelViewInfo"),
			simViewInfos[1](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			typename="ModelInfo"),
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
				Bitmap(
					imageSource="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
TkSuQmCC",
					extent={{-200,203},{203,-200}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\Schwan-IAD\\AppData\\Local\\Temp\\itiC6A9.tmp\\hlpD8DD.tmp\\PVConverter.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<HTML><HEAD><TITLE>Maximum power point tracker V1.0</TITLE>
<META content=3D=22text/html; charset=3Diso-8859-1=22 http-equiv=3DContent-T=
ype>
<STYLE type=3Dtext/css>
p, li =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px;=
 color: =23000000;=7D
.Ueberschrift1 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:14px; font-weight:bold; color:=23000000; margin-top:0; margin-bottom:6px=
;=7D
.Ueberschrift2 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; color:=23000000; margin-top:6px; margin-bottom:6=
px;=7D
.Ueberschrift3 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; font-style:italic; color:=23000000; margin-top:6=
px; margin-bottom:6px;=7D
.SymbolTab =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:=
12px; font-weight:bold; color:=23000000;=7D
</STYLE>
<LINK rel=3Dstylesheet href=3D=22../format_help.css=22>
<META name=3DGENERATOR content=3D=22MSHTML 9.00.8112.16450=22></HEAD>
<BODY bgColor=3D=23ffffff vLink=3D=23800080 link=3D=230000ff>
<P style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 class=3DUeberschrift1>M=
aximum power 
point tracker V1.0</P>
<HR style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 SIZE=3D1 noShade>

<TABLE border=3D1 cellSpacing=3D0 borderColor=3D=23ffffff borderColorLight=
=3D=23ffffff 
borderColorDark=3D=23ffffff cellPadding=3D2 width=3D=22100%=22 bgColor=3D=23=
cccccc>
  <TBODY>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Symbol:</P></TD>
    <TD bgColor=3D=23ffffff vAlign=3Dtop colSpan=3D3><IMG src=3D=22PVConvert=
er=5Csymbol.png=22 
      width=3D124 height=3D124></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Ident:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P 
  class=3DSymbolTab>GreenBuilding.Photovoltaics.Control.PVConverter</P></TD>=
</TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Version:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab>1.0</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>File:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab></P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Connectors:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>1-phase connection to Grid</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Grid1</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DC connection to PV system</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PVDC</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Demanded control voltage of photovoltaics module<=
/P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>MPP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Parameters:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Efficiency of PV-Converter</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>etaConverter</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Number of phases PVConverter is connected to</P><=
/TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PVPhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3DUeberschrift2>Description:</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>PV converter model is n=
ecessary 
to couple a photovoltaic system model with an AC-grid. Therefore, it is poss=
ible 
to define a 3-phase or single-phase connection. Internally the model either =
uses 
a B6- or B2-converter model. If the related maximum open-circuit-voltage of =
the 
PV system exceeds a value of 0.9 times of effective grid voltage, the PV 
converter has to be defined as a 3-phase converter. Maximum voltage of 3-pha=
se 
converter is 2.34 times of effective grid voltage. Using PV converter model =
as a 
single-phase converter avoids high reactive power demands for voltage 
conversion. To configure PV converter compare PV module data in model data =

directory with desired PV system configuration.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>PV converter uses the r=
esulting 
maximum-power-point-voltage ('MPP') to control the intermediate-circuit volt=
age 
at DC-side. Make sure that 'MPP'-connector is defined by the correspondent P=
V 
system. That way, it is ensured that PV systems provide maximum electrical p=
ower 
output at all. Normally, a PV system is controlled by a so called MPP-Tracke=
r, a 
system regulating the intermediate-circuit voltage at DC-side without knowin=
g 
the actual available MPP-voltage and current. So, they use measurements for =

voltage and current output for power regulation. These complex control 
algorithms are left out to reduce system complexity in the provided controll=
er 
model.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>&nbsp;</P></BODY></HTML=
>


----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: PVConverter\\symbol.png

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

----$iti$--"),
		experiment(
			StopTime=0.999999999999994,
			StartTime=0,
			Interval=0.00199999999999999,
			__iti_MaxInterval="10",
			__iti_AbsTolerance="1e-06"));
end MPP_AC;
