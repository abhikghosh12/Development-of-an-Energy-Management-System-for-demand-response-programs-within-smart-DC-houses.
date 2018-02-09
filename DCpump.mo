// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model DCpump "DCpump.mo"
	GreenBuilding.Interfaces.Thermal.VolumeFlowIn ReturnHP "Return pipe" annotation(Placement(
		transformation(extent={{240,-25},{260,-5}}),
		iconTransformation(extent={{90,-60},{110,-40}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowOut FlowHP "flow pipe" annotation(Placement(
		transformation(extent={{240,30},{260,50}}),
		iconTransformation(extent={{90,40},{110,60}})));
	GreenBuilding.Interfaces.Electrical.DC Grid "DC grid connection" annotation(Placement(
		transformation(extent={{20,-75},{40,-55}}),
		iconTransformation(extent={{-60,-110},{-40,-90}})));
	input Modelica.Blocks.Interfaces.RealInput qvRef(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h") "Reference volume flow of circulation pump" annotation(
		Placement(
			transformation(
				origin={115,105},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={0,100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Volume Flow",
			tab="Results 1",
			showAs=ShowAs.Result));
	GreenBuilding.Interfaces.Thermal.DefineVolumeFlow ToFlow annotation(Placement(transformation(extent={{200,30},{220,50}})));
	GreenBuilding.Interfaces.Thermal.ExtractVolumeFlow FromReturn annotation(Placement(transformation(extent={{219,-23},{199,-3}})));
	GreenBuilding.Interfaces.Electrical.DefineCurrentDC GridConnection annotation(
		Placement(transformation(
			origin={95,-70},
			extent={{-10,-10},{10,10}},
			rotation=-90)),
		Dialog(
			group="Coefficient of Performance",
			tab="Results 1"));
	Real ESP(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy demand of pump" annotation(Dialog(
		group="Energy",
		tab="Results 2",
		showAs=ShowAs.Result));
	Real qv(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h") "Actual volume flow of source pump" annotation(Dialog(
		group="Volume Flow",
		tab="Results 1",
		showAs=ShowAs.Result));
	Modelica.Blocks.Tables.CombiTable1D PelCP(
		tableOnFile=true,
		tableName=CPTable,
		fileName=HPFile) "Electrical power demand of circulation pump" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="Coefficient of Performance",
			tab="Results 1"));
	Real PSP(
		quantity="Basics.Power",
		displayUnit="kW") "Effective power of source pump" annotation(Dialog(
		group="Electrical Power",
		tab="Results 2",
		showAs=ShowAs.Result));
	parameter Real qvMax(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h")=0.00083333333333333328 "Maximum volume flow of CP" annotation(Dialog(
		group="Boundaries",
		tab="CP - Dimensions"));
	parameter Real qvMin(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h")=0.00000000044444444443 "Minimum volume flow of CP" annotation(Dialog(
		group="Boundaries",
		tab="CP - Dimensions"));
	parameter Real tSP=0.444444444444443;
	parameter String HPFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\circulation_pump\\CPDC_25_60.txt" "File name where electrical power data of circulation pump is located" annotation(Dialog(
		group="Circulation Pump - Power Data",
		tab="Parameters 1"));
	parameter String CPTable="P_CP" "Table name where electrical power data of circulation pump is located" annotation(Dialog(
		group="Circulation Pump - Power Data",
		tab="Parameters 1"));
	initial equation
		qv=max(min((qvRef),qvMax),qvMin);
	equation
						tSP*der(ToFlow.qvMedium)+ToFlow.qvMedium=max(min(qvRef,qvMax),qvMin);
						PelCP.u[1]=FromReturn.qvMedium;
						PSP=-PelCP.y[1];
					
					FromReturn.TMedium=ToFlow.TMedium;
				if (GridConnection.V>1e-10) then
								GridConnection.I=abs(PSP)/GridConnection.V;
								
							else
								GridConnection.I=0;
								
					end if;
					
					der(ESP)=PSP;
					
		connect(ToFlow.Pipe,FlowHP) annotation(Line(
				points={{220,40},{225,40},{245,40},{250,40}},
				color={190,30,45}));
			
		connect(FromReturn.Pipe,ReturnHP) annotation(Line(
				points={{219,-13},{224,-13},{245,-13},{245,-15},{250,-15}},
				color={190,30,45},
				thickness=0.0625));
		connect(Grid,GridConnection.FlowCurrent) annotation(Line(points={{30,-65},{35,-65},{35,-85},{95,-85},{95,-80}}));
	annotation(experiment(
		StopTime=86400,
		StartTime=0,
		Tolerance=1e-006,
		Interval=172.8,
		MinInterval="1e-009",
		MaxInterval="10",
		AbsTolerance="1e-06"));
end DCpump;
