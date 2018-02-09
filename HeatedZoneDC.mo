// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model HeatedZoneDC "HeatedZoneDC.mo"
	import GreenBuilding.Utilities.Functions;
	GreenBuilding.Interfaces.Electrical.DC Grid "Grid connection to Grid" annotation(Placement(
		transformation(extent={{470,-710},{490,-690}}),
		iconTransformation(extent={{140,-210},{160,-190}})));
	GreenBuilding.Interfaces.Electrical.DefineCurrentDC GridConnection annotation(
		Placement(transformation(
			origin={480,-634},
			extent={{10,-10},{-10,10}},
			rotation=90)),
		Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2"));
	protected
		InnerMass Masses[Mass] "Inner masses model" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		Boundary Boundaries[Bound] "Boundary model" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
	public
		input Modelica.Blocks.Interfaces.RealInput TZoneRef(
			quantity="Thermics.Temp",
			displayUnit="°C") if LoadCalculation "Desired zone temperature" annotation(
			Placement(
				transformation(extent={{645,-495},{605,-455}}),
				iconTransformation(
					origin={200,200},
					extent={{20,-20},{-20,20}},
					rotation=90)),
			Dialog(
				group="Temperature",
				tab="Results 1",
				showAs=ShowAs.Result));
		output Modelica.Blocks.Interfaces.RealOutput TZone(
			quantity="Thermics.Temp",
			displayUnit="°C") "Zone temperature" annotation(
			Placement(
				transformation(
					origin={400,-665},
					extent={{-10,-10},{10,10}},
					rotation=-90),
				iconTransformation(
					origin={-150,-200},
					extent={{-10,-10},{10,10}},
					rotation=-90)),
			Dialog(
				group="Temperature",
				tab="Results 1",
				showAs=ShowAs.Result));
	protected
		Real TZoneAct(
			quantity="Thermics.Temp",
			displayUnit="°C") "Zone temperature" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TAmbientBound[Bound](
			quantity="Thermics.Temp",
			displayUnit="°C") "Input vector for ambient temperatures for each boundary" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TFlowHeat(
			quantity="Thermics.Temp",
			displayUnit="°C") "Flow temperature of heating system" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TReturnHeat(
			quantity="Thermics.Temp",
			displayUnit="°C") "Return temperature of heating system" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TGround[Bound](
			quantity="Thermics.Temp",
			displayUnit="°C") "Ground temperature" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real deltaTBound[Bound](
			quantity="Thermics.TempDiff",
			displayUnit="K") "Temperature difference between inner and outer part of Boundary" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TBoundIn[Bound](
			start=(zeros(Bound))'°C',
			each fixed=true,
			quantity="Thermics.Temp",
			displayUnit="°C") "Inner part temperature of Boundary" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real TBoundOut[Bound](
			start=(zeros(Bound))'°C',
			each fixed=true,
			quantity="Thermics.Temp",
			displayUnit="°C") "Outer part temperature of Boundary" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
	public
		input Modelica.Blocks.Interfaces.RealInput WindowShading[Bound] if useWindowShading "Vector for external shading of windows for each boundary (0: fully irradiated, 1: fully shaded)" annotation(
			Placement(
				transformation(extent={{645,-545},{605,-505}}),
				iconTransformation(extent={{370,-20},{330,20}})),
			Dialog(
				group="Others",
				tab="Results 1",
				showAs=ShowAs.Result));
		GreenBuilding.Interfaces.Thermal.DefineVolumeFlow ToReturn if not LoadCalculation and Heat annotation(
			Placement(transformation(extent={{385,-515},{365,-495}})),
			Dialog(
				group="Others",
				tab="Results 1"));
		GreenBuilding.Interfaces.Thermal.ExtractVolumeFlow FromFlow if not LoadCalculation and Heat annotation(
			Placement(transformation(extent={{365,-470},{385,-450}})),
			Dialog(
				group="Others",
				tab="Results 1"));
	protected
		Real AngleBound[Bound](
			quantity="Geometry.Angle",
			displayUnit="°") "Radiation angle to boundary" annotation(Dialog(
			group="Others",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real qvHeat(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h") "Volume flow of heating system" annotation(Dialog(
			group="Others",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real CZoneAir(
			quantity="Thermodynamics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)") "Air heat capacity of the zone" annotation(Dialog(
			group="Others",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real CZoneMass(
			quantity="Thermodynamics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)") "Mass heat capacity of the zone" annotation(Dialog(
			group="Others",
			tab="Results 1",
			showAs=ShowAs.Result));
		Curve2D TOverLog(
			f={{0,0,0,0,0,0,0,0,0,0,0,
			0,0,0},{0,4.994998332,0,0,0,0,0,0,0,
			0,0,0,0,0},{0,7.213475204,9.994999166,0,0,0,0,
			0,0,0,0,0,0,0},{0,9.102392266000001,12.33151731,14.99499944,0,
			0,0,0,0,0,0,0,0,0},{0,10.82021281,14.42695041,
			17.38029748,19.99499958,0,0,0,0,0,0,0,0,0},{0,
			12.42669869,16.37035002,19.57615189,22.40710059,24.99499967,0,0,0,0,0,0,0,
			0},{0,13.95276566,18.20478453,21.64042561,24.66303462,27.42407474,29.99499972,0,0,0,0,
			0,0,0},{0,15.41695027,19.95589,23.60445002,26.80410439,29.72013412,32.43579597,34.99499976,0,
			0,0,0,0,0},{0,16.83144214,21.64042561,25.4886362,28.85390082,31.91464718,34.76059497,
			37.44437845,39.99499979,0,0,0,0,0},{0,18.20478453,23.2700791,27.3071768,30.82879328,
			34.02595056,36.99455194,39.79079143,42.45093508,44.99499981,0,0,0,0},{0,19.54325169,24.85339738,
			29.07042408,32.74070004,36.06737602,39.15230378,42.05509878,44.81420118,47.45610791,49.99499983,0,0,0},{0,
			20.85161957,26.39686192,30.78621092,34.59862441,38.04898211,41.2448825,44.24924394,47.10260403,49.83288655,52.46029344,54.99499985,0,
			0},{0,22.13362824,27.90553133,32.46063842,36.40956907,39.97858348,43.28085123,46.38249036,49.32606925,52.14089245,54.84814948,
			57.46374983,59.99499986,0},{0,23.39227472,29.38344697,34.09857192,38.17911105,41.86239758,45.26701724,48.46219689,51.49247692,
			54.38850217,57.1724203,59.86085297,62.46665243,64.99499987},{0,24.63000681,30.83390054,35.70396771,39.91178001,43.70546947,47.20890005,
			50.49432643,53.60820879,56.58249614,59.44026824,62.19883923,64.87159195,67.46912450000001},{0,25.84885611,32.25961713,37.28009607,41.61131605,
			45.51196133,49.11105006,52.48379204,55.67852029,58.72845567,61.65758656,64.48390199000001,67.22130177,69.88078998}},
			x(
				mono=1,
				interpol=3,
				extra=true,
				mirror=false,
				cycle=false)={0,5,10,15,20,25,30,35,40,45,
			50,55,60,65},
			y(
				mono=1,
				interpol=1,
				extra=true,
				mirror=false,
				cycle=false)={0,5,10,15,20,25,30,35,40,45,
			50,55,60,65,70,75}) "Logarithmic over temperature of heating system" annotation(
			Placement(transformation(extent={{-10,10},{10,30}})),
			Dialog(
				group="Others",
				tab="Results 1"));
		Curve2D TOverLogNorm(
			f={{0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,4.994998332,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,7.213475204,9.994999166,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,9.102392266000001,12.33151731,14.99499944,0.1,0.1,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,10.82021281,14.42695041,17.38029748,19.99499958,0.1,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,12.42669869,16.37035002,19.57615189,22.40710059,24.99499967,0.1,0.1,0.1,0.1,0.1,
			0.1},{0.1,13.95276566,18.20478453,21.64042561,24.66303462,27.42407474,29.99499972,0.1,0.1,0.1,0.1,
			0.1},{0.1,15.41695027,19.95589,23.60445002,26.80410439,29.72013412,32.43579597,34.99499976,0.1,0.1,0.1,
			0.1},{0.1,16.83144214,21.64042561,25.4886362,28.85390082,31.91464718,34.76059497,37.44437845,39.99499979,0.1,0.1,
			0.1},{0.1,18.20478453,23.2700791,27.3071768,30.82879328,34.02595056,36.99455194,39.79079143,42.45093508,44.99499981,0.1,
			0.1},{0.1,19.54325169,24.85339738,29.07042408,32.74070004,36.06737602,39.15230378,42.05509878,44.81420118,47.45610791,49.99499983,
			0.1},{0.1,20.85161957,26.39686192,30.78621092,34.59862441,38.04898211,41.2448825,44.24924394,47.10260403,49.83288655,52.46029344,
			54.99499985},{0.1,22.13362824,27.90553133,32.46063842,36.40956907,39.97858348,43.28085123,46.38249036,49.32606925,52.14089245,54.84814948,
			57.46374983},{0.1,23.39227472,29.38344697,34.09857192,38.17911105,41.86239758,45.26701724,48.46219689,51.49247692,54.38850217,57.1724203,
			59.86085297},{0.1,24.63000681,30.83390054,35.70396771,39.91178001,43.70546947,47.20890005,50.49432643,53.60820879,56.58249614,59.44026824,
			62.19883923},{0.1,25.84885611,32.25961713,37.28009607,41.61131605,45.51196133,49.11105006,52.48379204,55.67852029,58.72845567,61.65758656,
			64.48390199000001}},
			x(
				mono=1,
				interpol=3,
				extra=true,
				mirror=false,
				cycle=false)={0,5,10,15,20,25,30,35,40,45,
			50,55},
			y(
				mono=1,
				interpol=1,
				extra=true,
				mirror=false,
				cycle=false)={0,5,10,15,20,25,30,35,40,45,
			50,55,60,65,70,75}) "Normal logarithmic over temperature of heating system" annotation(
			Placement(transformation(extent={{-10,10},{10,30}})),
			Dialog(
				group="Others",
				tab="Results 1"));
	public
		output Modelica.Blocks.Interfaces.RealOutput HeatCoolLoad(
			quantity="Basics.Power",
			displayUnit="kW") if LoadCalculation "Control output for resulting heating and cooling load when Heating-Cooling-Load-Calculation is used" annotation(
			Placement(
				transformation(
					origin={450,-665},
					extent={{-10,-10},{10,10}},
					rotation=-90),
				iconTransformation(
					origin={0,-200},
					extent={{-10,-10},{10,10}},
					rotation=-90)),
			Dialog(
				group="Heating and Cooling Power",
				tab="Results 1",
				showAs=ShowAs.Result));
		Real QHeatCoolLoad(
			quantity="Basics.Power",
			displayUnit="kW") "Heating/cooling load of building" annotation(Dialog(
			group="Heating and Cooling Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real QHeat(
			quantity="Basics.Power",
			displayUnit="kW") "Heat power" annotation(Dialog(
			group="Heating and Cooling Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real QTotal(
			quantity="Basics.Power",
			displayUnit="kW") "Total heating/cooling load" annotation(Dialog(
			group="Heating and Cooling Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real PVent(
			quantity="Basics.Power",
			displayUnit="kW") "Effective ventilation power" annotation(Dialog(
			group="Electrical Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real QVent(
			quantity="Basics.Power",
			displayUnit="kW") "Reactive ventilation power" annotation(Dialog(
			group="Electrical Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real Pel(
			quantity="Basics.Power",
			displayUnit="kW") "Electrical effective power of the zone" annotation(Dialog(
			group="Electrical Power",
			tab="Results 1",
			showAs=ShowAs.Result));
	protected
		Real Qel(
			quantity="Basics.Power",
			displayUnit="kW") "Electrical reactive power of the zone" annotation(Dialog(
			group="Electrical Power",
			tab="Results 1",
			showAs=ShowAs.Result));
	public
		Real EHeat(
			quantity="Basics.Energy",
			displayUnit="kWh") "Energy, used for heating the zone during simulation time period" annotation(Dialog(
			group="Energy",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real Eel(
			quantity="Basics.Energy",
			displayUnit="kWh") "Electrical energy demand of the zone during simulation time period" annotation(Dialog(
			group="Energy",
			tab="Results 1",
			showAs=ShowAs.Result));
	protected
		Real QTransWindowAbsorp[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Window transmission losses correction vector for solar yields" annotation(Dialog(
			group="Window - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QTransWindow[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Transmission losses vector for window" annotation(Dialog(
			group="Window - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QTransOthers[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Transmission losses vector for other surfaces" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBound[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Heat power of Boundary" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBoundIn[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Inner heat losses/gains due to Boundary" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBoundOut[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Outer heat losses/gains due to Boundary" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBoundAbsorp[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Transmission losses correction vector for Boundaries due to radiation absorption" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBoundChange[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Interchanged heat between outer and inner parts of Boundaries" annotation(Dialog(
			group="Walls and other boundaries - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QLAirLeak(
			quantity="Basics.Power",
			displayUnit="kW") "Ventilation losses by air leak" annotation(Dialog(
			group="Ventilation - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QAirComfort(
			quantity="Basics.Power",
			displayUnit="kW") "Ventilation losses by comfortable air flow" annotation(Dialog(
			group="Ventilation - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QHeatBridge[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Transmission losses vector for heat bridge losses" annotation(Dialog(
			group="Heat Bridge - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QHeatBridgeAbsorp[Bound](
			quantity="Basics.Power",
			displayUnit="kW") "Transmission losses correction vector for heat bridges due to radiation absorption" annotation(Dialog(
			group="Heat Bridge - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QPerson(
			quantity="Basics.Power",
			displayUnit="kW") "Inner heat yields and losses by persons" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QLight(
			quantity="Basics.Power",
			displayUnit="kW") "Inner heat yields by installed light system" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QMachine(
			quantity="Basics.Power",
			displayUnit="kW") "Inner heat yields by installed machines" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QNorm(
			quantity="Basics.Power",
			displayUnit="kW") "Norm heat yields/losses" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QInner(
			quantity="Basics.Power",
			displayUnit="kW") "Inner heat yields/losses" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QBase(
			quantity="Basics.Power",
			displayUnit="kW") "Basic heat yields/losses" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real QelHeat(
			quantity="Basics.Power",
			displayUnit="kW") "Electrical power causing inner heat gains" annotation(Dialog(
			group="Inner yields and losses - Heating and Cooling",
			tab="Results 2",
			showAs=ShowAs.Result));
	public
		Modelica.Blocks.Tables.CombiTable1D CoolLoadFactorPerson(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=CoolFactorTable,
			fileName=DINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D CoolLoadFactorLigth(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=CoolFactorTable,
			fileName=DINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D CoolLoadFactorMachine(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=CoolFactorTable,
			fileName=DINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D AppliedLoadFactorLight(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=LoadLightTable,
			fileName=DINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D AppliedLoadFactorMachine(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=LoadMachineTable,
			fileName=DINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D PelDIN(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=PelDINTable,
			fileName=PelDINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D NumberPersonDIN(
			tableOnFile=DINcalc,
			table=[0,0],
			tableName=NumberPersonDINTable,
			fileName=NumberPersonDINFile) if DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D NumberPerson(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=NumberPersonTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D ElectricalPower(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=PelTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D ReactivePower(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=QelTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D BaseLoad(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=BaseLoadTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D NormLoad(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=NormLoadTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D MachineLoad(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=MachineLoadTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D LightLoad(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=LightLoadTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
		Modelica.Blocks.Tables.CombiTable1D InnerLoad(
			tableOnFile=not DINcalc,
			table=[0,0],
			tableName=InnerLoadTable,
			fileName=InputDataFile) if not DINcalc annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Inner yields and losses - Heating and Cooling",
				tab="Results 2"));
	protected
		parameter Boolean Ground1=if Bound>0 then (if not contactBound1>0 then groundContact1 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground2=if Bound>1 then (if not contactBound2>0 then groundContact2 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground3=if Bound>2 then (if not contactBound3>0 then groundContact3 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground4=if Bound>3 then (if not contactBound4>0 then groundContact4 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground5=if Bound>4 then (if not contactBound5>0 then groundContact5 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground6=if Bound>5 then (if not contactBound6>0 then groundContact6 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground7=if Bound>6 then (if not contactBound7>0 then groundContact7 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground8=if Bound>7 then (if not contactBound8>0 then groundContact8 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
		parameter Boolean Ground9=if Bound>8 then (if not contactBound9>0 then groundContact9 else false) else false "Auxiliary parameter for parameter dialogue initialization ('depthBound1')" annotation(Dialog(
			group="Ground Definitions",
			tab="Model Initialization"));
	public
		parameter Integer ZoneIndex=1 "Zone Index" annotation(Dialog(
			group="Zones",
			tab="Model Initialization"));
		parameter Integer NumberZones=1 "Number of Zones" annotation(Dialog(
			group="Zones",
			tab="Model Initialization"));
	protected
		parameter Integer MaxNumberZones=15 "Maximum number of zones" annotation(Dialog(
			group="Zones",
			tab="Model Initialization"));
	public
		parameter Integer Bound=6 "Number of Boundaries" annotation(Dialog(
			group="Boundaries",
			tab="Model Initialization"));
	protected
		parameter Integer BoundMax=9 "Maximum number of Bounderies" annotation(Dialog(
			group="Boundaries",
			tab="Model Initialization"));
		parameter Integer BoundMin=1 "Minimum number of Boundaries" annotation(Dialog(
			group="Boundaries",
			tab="Model Initialization"));
	public
		parameter Integer Mass=1 "Number of inner Masses" annotation(Dialog(
			group="Inner Masses",
			tab="Model Initialization"));
	protected
		parameter Integer MassMax=4 "Maximum number of inner Masses" annotation(Dialog(
			group="Inner Masses",
			tab="Model Initialization"));
		parameter Integer MassMin=0 "Minimum number of inner Masses" annotation(Dialog(
			group="Inner Masses",
			tab="Model Initialization"));
	public
		parameter Real TZoneInit(
			quantity="Thermics.Temp",
			displayUnit="°C")=294.14999999999998 if not LoadCalculation "Initial zone temperature" annotation(Dialog(
			group="Temperatures",
			tab="Model Initialization"));
		parameter Real TReturnHeatInit(
			quantity="Thermics.Temp",
			displayUnit="°C")=303.14999999999998 if not LoadCalculation and Heat "Initial return temperature of heating system" annotation(Dialog(
			group="Temperatures",
			tab="Model Initialization"));
		parameter Boolean LoadCalculation=false "If enabled, only cooling and heating load calculation, else dynamic zone temperature simulation" annotation(Dialog(
			group="Calculation Mode",
			tab="Model Initialization"));
		parameter Boolean useDayTime=true "If enabled, database = HourOfDay, else database = HourOfYear" annotation(Dialog(
			group="Database",
			tab="Model Initialization"));
		parameter Boolean useWindowShading=false "External shading of windows, separately for each boundary is enabled" annotation(Dialog(
			group="Shading",
			tab="Model Initialization"));
		parameter Real AZone(
			quantity="Geometry.Area",
			displayUnit="m²")=100 "Net floor space of the zone" annotation(Dialog(
			group="Zone Dimensions",
			tab="Zone"));
		parameter Real hZone(
			quantity="Geometry.Length",
			displayUnit="m")=2.5 "Height of zone" annotation(Dialog(
			group="Zone Dimensions",
			tab="Zone"));
		parameter Real PLightInstall(
			quantity="Basics.Power",
			displayUnit="W")=60 if DINcalc "Installed electrical power of light" annotation(Dialog(
			group="Installed Electric Devices",
			tab="Zone"));
		parameter Real PMachineInstall(
			quantity="Basics.Power",
			displayUnit="W")=600 if DINcalc "Installed electrical power of machines" annotation(Dialog(
			group="Installed Electric Devices",
			tab="Zone"));
		parameter Real etaMachine(
			quantity="Basics.RelMagnitude",
			displayUnit="%")=0.8 if DINcalc "Efficiency factor of machines" annotation(Dialog(
			group="Installed Electric Devices",
			tab="Zone"));
		parameter Boolean DINcalc=false "DIN calculations enabled/disabled" annotation(Dialog(
			group="DIN Calculations Enabling",
			tab="Heat and Cool Load Factors I"));
		parameter String CoolFactorTable="Si" if DINcalc "Table name for DIN cool load factors" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String LoadLightTable="m_light" if DINcalc "Table name for DIN load factors for light" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String LoadMachineTable="m_machine" if DINcalc "Table name for DIN load factors for machines" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String DINFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\building\\DIN_factors\\DIN_factors.txt" if DINcalc "File name for DIN cool and load factors" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String NumberPersonDINFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\building\\DIN_factors\\DIN_persons.txt" if DINcalc "File name for number of persons while DIN calculations" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String NumberPersonDINTable="person" if DINcalc "Table name for number of persons while DIN calculations" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String PelDINFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\building\\DIN_factors\\DIN_electrical.txt" if DINcalc "File name for electrical power while DIN calculations" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String PelDINTable="pel" if DINcalc "Table name for electrical power while DIN calculations" annotation(Dialog(
			group="DIN Data",
			tab="Heat and Cool Load Factors I"));
		parameter String InputDataFile=GreenBuilding.Utilities.Functions.getSimulationDataDirectory()+"\\building\\inner_loads\\zone_x.txt" if not DINcalc "File name for inner loads" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String NumberPersonTable="person" if not DINcalc "Table name for inner loads due to body heat of that number of person" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String BaseLoadTable="baseLoad" if not DINcalc "Table name for inner loads due to basic loads" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String NormLoadTable="normLoad" if not DINcalc "Table name for inner loads due to normal loads" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String MachineLoadTable="machineLoad" if not DINcalc "Table name for inner loads due to machines" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String LightLoadTable="lightLoad" if not DINcalc "Table name for inner loads due to light" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String InnerLoadTable="innerLoad" if not DINcalc "Table name for inner loads due to other loads" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String PelTable="pel" if not DINcalc "Table name for further electrical power characteristics" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter String QelTable="qel" if not DINcalc "Table name for further electrical power characteristics" annotation(Dialog(
			group="Input Data",
			tab="Heat and Cool Load Factors II"));
		parameter Boolean Heat=true "Heating is enabled/disabled" annotation(Dialog(
			group="Heating Enabling",
			tab="Heating System"));
		parameter Real cpMedHeat(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=4177 if not LoadCalculation and Heat "Specific heat capacity of heat media" annotation(Dialog(
			group="Heating Medium",
			tab="Heating System"));
		parameter Real rhoMedHeat(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1000 if not LoadCalculation and Heat "Density of heat media" annotation(Dialog(
			group="Heating Medium",
			tab="Heating System"));
		parameter Real n=1.1 if not LoadCalculation and Heat "Heating system exponent (1.1: floor heating, 1.2-1.3: panel radiator, 1.25: ribbed radiator, 1.3: radiator, 1.25-1.45: convector)" annotation(Dialog(
			group="Heating System",
			tab="Heating System"));
		parameter Real TFlowHeatNorm(
			quantity="Thermics.Temp",
			displayUnit="°C")=308.14999999999998 if not LoadCalculation and Heat "Normal flow temperature of heating system" annotation(Dialog(
			group="Heating System",
			tab="Heating System"));
		parameter Real TReturnHeatNorm(
			quantity="Thermics.Temp",
			displayUnit="°C")=301.14999999999998 if not LoadCalculation and Heat "Normal return temperature of heating system" annotation(Dialog(
			group="Heating System",
			tab="Heating System"));
		parameter Real TZoneNorm(
			quantity="Thermics.Temp",
			displayUnit="°C")=293.14999999999998 if not LoadCalculation and Heat "Normal zone temperature for heating system" annotation(Dialog(
			group="Heating System",
			tab="Heating System"));
		parameter Real QHeatNorm(
			quantity="Thermics.HeatFlowSurf",
			displayUnit="W/m²")=50 if not LoadCalculation and Heat "Normal heating power" annotation(Dialog(
			group="Heating System Dimensions",
			tab="Heating System"));
		parameter Real VHeatMedium(
			quantity="Geometry.Volume",
			displayUnit="l")=0.10000000000000001 if not LoadCalculation and Heat "Volume of heating system" annotation(Dialog(
			group="Heating System Dimensions",
			tab="Heating System"));
		parameter Real QBody(
			quantity="Basics.Power",
			displayUnit="W")=80 "Body heat dissipation per person" annotation(Dialog(
			group="Inner Yields",
			tab="Heat Yields and Losses"));
		parameter Real QPersonColdWater(
			quantity="Basics.Power",
			displayUnit="W")=-30 "Individual heat losses by cold water usage per person" annotation(Dialog(
			group="Inner Yields",
			tab="Heat Yields and Losses"));
		parameter Real QPersonElectricity(
			quantity="Basics.Power",
			displayUnit="W")=60 "Heat dissipation by usage of electrical devices per person" annotation(Dialog(
			group="Inner Yields",
			tab="Heat Yields and Losses"));
		parameter Real LAirLeak(
			quantity="Basics.Gradient",
			displayUnit="1/h")=0.00013888888888888889 "Air leak of zone" annotation(Dialog(
			group="Ventilations Losses",
			tab="Heat Yields and Losses"));
		parameter Real LComfortVentilation(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.0069444444444444441 "Air volume flow of ventilation due to comfort" annotation(Dialog(
			group="Ventilations Losses",
			tab="Heat Yields and Losses"));
		parameter Boolean useVentilationSystem=false "If enabled, ventilation losses and gains are modified by VentilationHeatExchangeRate" annotation(Dialog(
			group="Ventilation System",
			tab="Heat Yields and Losses"));
		parameter Real VentilationHeatExchangeRate(
			quantity="Basics.RelMagnitude",
			displayUnit="%")=0.70000000000000007 if useVentilationSystem "Heat exchange correction factor (heating and cooling) for ventilation losses by using ventilation systems" annotation(Dialog(
			group="Ventilation System",
			tab="Heat Yields and Losses"));
		parameter Real VentPower(
			quantity="Basics.Power",
			displayUnit="W")=1500 if useVentilationSystem "Electrical power of ventilation system [W/(m3/s)]" annotation(Dialog(
			group="Ventilation System",
			tab="Heat Yields and Losses"));
		parameter Real cosPhiVent=0.7 if useVentilationSystem "Power factor of ventilation system" annotation(Dialog(
			group="Ventilation System",
			tab="Heat Yields and Losses"));
		parameter Real uHeatBridge(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.05 "Equlivalent additional heat transmission value for heat bridges" annotation(Dialog(
			group="Heat Bridge Losses",
			tab="Heat Yields and Losses"));
		parameter Real VMass1(
			quantity="Geometry.Volume",
			displayUnit="m³")=6 if Mass>0 "Volume of inner Mass 1" annotation(Dialog(
			group="Inner Mass 1",
			tab="Inner Masses Dimensions I"));
		parameter Real cpMass1(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Mass>0 "Specific heat capacity of inner Mass 1" annotation(Dialog(
			group="Inner Mass 1",
			tab="Inner Masses Dimensions I"));
		parameter Real rhoMass1(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Mass>0 "Density of inner Mass 1" annotation(Dialog(
			group="Inner Mass 1",
			tab="Inner Masses Dimensions I"));
		parameter Real VMass2(
			quantity="Geometry.Volume",
			displayUnit="m³")=6 if Mass>1 "Volume of inner Mass 2" annotation(Dialog(
			group="Inner Mass 2",
			tab="Inner Masses Dimensions I"));
		parameter Real cpMass2(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Mass>1 "Specific heat capacity of inner Mass 2" annotation(Dialog(
			group="Inner Mass 2",
			tab="Inner Masses Dimensions I"));
		parameter Real rhoMass2(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Mass>1 "Density of inner Mass 2" annotation(Dialog(
			group="Inner Mass 2",
			tab="Inner Masses Dimensions I"));
		parameter Real VMass3(
			quantity="Geometry.Volume",
			displayUnit="m³")=6 if Mass>2 "Volume of inner Mass 3" annotation(Dialog(
			group="Inner Mass 3",
			tab="Inner Masses Dimensions II"));
		parameter Real cpMass3(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Mass>2 "Specific heat capacity of inner Mass 3" annotation(Dialog(
			group="Inner Mass 3",
			tab="Inner Masses Dimensions II"));
		parameter Real rhoMass3(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Mass>2 "Density of inner Mass 3" annotation(Dialog(
			group="Inner Mass 3",
			tab="Inner Masses Dimensions II"));
		parameter Real VMass4(
			quantity="Geometry.Volume",
			displayUnit="m³")=6 if Mass>3 "Volume of inner Mass 4" annotation(Dialog(
			group="Inner Mass 4",
			tab="Inner Masses Dimensions II"));
		parameter Real cpMass4(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Mass>3 "Specific heat capacity of inner Mass 4" annotation(Dialog(
			group="Inner Mass 4",
			tab="Inner Masses Dimensions II"));
		parameter Real rhoMass4(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Mass>3 "Density of inner Mass 4" annotation(Dialog(
			group="Inner Mass 4",
			tab="Inner Masses Dimensions II"));
		parameter Integer contactBound1=0 "Boundary 1 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 1 - I"));
		parameter Real ABound1(
			quantity="Geometry.Area",
			displayUnit="m²")=30 "Surface area of boundary 1" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 1 - I"));
		parameter Real AWindow1(
			quantity="Geometry.Area",
			displayUnit="m²")=5 "Window surface area of boundary 1" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 1 - I"));
		parameter Real AOthers1(
			quantity="Geometry.Area",
			displayUnit="m²")=0 "Other surface area of boundary 1" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 1 - I"));
		parameter Real dBound1(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 "Thickness of boundary 1" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 1 - I"));
		parameter Real rhoBound1(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 "Density of boundary 1" annotation(Dialog(
			group="Material",
			tab="Boundary 1 - I"));
		parameter Real cpBound1(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 "Specific heat capacity of boundary 1" annotation(Dialog(
			group="Material",
			tab="Boundary 1 - I"));
		parameter Real uBound1(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 "Heat transmission value of boundary 1" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 1 - I"));
		parameter Real uWindow1(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 "Heat transmission value of window in boundary 1" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 1 - I"));
		parameter Real uOthers1(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 "Heat transmission value of other surfaces in boundary 1" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 1 - I"));
		parameter Boolean groundContact1=false if not contactBound1>0 "Boundary 1 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 1 - II"));
		parameter Real depthBound1(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Ground1 "Depth of boundary 1, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 1 - II"));
		parameter Real epsDirt1=0.1 "Dirt correction value for window in boundary 1 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 1 - II"));
		parameter Real epsShading1=0.2 "Shading correction value for boundary 1 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 1 - II"));
		parameter Real epsFrame1=0.2 "Frame correction value for window in boundary 1 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 1 - II"));
		parameter Real alphaInclination1(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 "Inclination angle of boundary 1" annotation(Dialog(
			group="Alignment",
			tab="Boundary 1 - II"));
		parameter Real alphaOrientation1(
			quantity="Geometry.Angle",
			displayUnit="°")=0 "Orientation angle of boundary 1" annotation(Dialog(
			group="Alignment",
			tab="Boundary 1 - II"));
		parameter Real gWindow1=0.6 "Total translucency of window in boundary 1" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 1 - II"));
		parameter Real alphaBound1=0.2 "Absorption coefficient of boundary 1" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 1 - II"));
		parameter Real alphaBoundOut1(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if not Ground1 "Outer heat transmission coefficient of boundary 1" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 1 - II"));
		parameter Real alphaBoundIn1(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 "Inner heat transmission coefficient of boundary 1" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 1 - II"));
		parameter Integer contactBound2=0 if Bound>1 "Boundary 2 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 2 - I"));
		parameter Real ABound2(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>1 "Surface area of boundary 2" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 2 - I"));
		parameter Real AWindow2(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>1 "Window surface area of boundary 2" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 2 - I"));
		parameter Real AOthers2(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>1 "Other surface area of boundary 2" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 2 - I"));
		parameter Real dBound2(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>1 "Thickness of boundary 2" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 2 - I"));
		parameter Real rhoBound2(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>1 "Density of boundary 2" annotation(Dialog(
			group="Material",
			tab="Boundary 2 - I"));
		parameter Real cpBound2(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>1 "Specific heat capacity of boundary 2" annotation(Dialog(
			group="Material",
			tab="Boundary 2 - I"));
		parameter Real uBound2(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>1 "Heat transmission value of boundary 2" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 2 - I"));
		parameter Real uWindow2(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>1 "Heat transmission value of window in boundary 2" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 2 - I"));
		parameter Real uOthers2(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>1 "Heat transmission value of other surfaces in boundary 2" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 2 - I"));
		parameter Boolean groundContact2=false if Bound>1 and not contactBound2>0 "Boundary 2 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 2 - II"));
		parameter Real depthBound2(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>1 and Ground2 "Depth of boundary 2, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 2 - II"));
		parameter Real epsDirt2=0.1 if Bound>1 "Dirt correction value for window in boundary 2 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 2 - II"));
		parameter Real epsShading2=0.2 if Bound>1 "shading correction value for  Boundary 2 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 2 - II"));
		parameter Real epsFrame2=0.2 if Bound>1 "Frame correction value for window in boundary 2 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 2 - II"));
		parameter Real alphaInclination2(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>1 "Inclination angle of boundary 2" annotation(Dialog(
			group="Alignment",
			tab="Boundary 2 - II"));
		parameter Real alphaOrientation2(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>1 "Orientation angle of boundary 2" annotation(Dialog(
			group="Alignment",
			tab="Boundary 2 - II"));
		parameter Real gWindow2=0.6 if Bound>1 "Total translucency of window in boundary 2" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 2 - II"));
		parameter Real alphaBound2=0.2 if Bound>1 "Absorption coefficient of boundary 2" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 2 - II"));
		parameter Real alphaBoundOut2(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>1 and not Ground2 "Outer heat transmission coefficient of boundary 2" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 2 - II"));
		parameter Real alphaBoundIn2(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>1 "Inner heat transmission coefficient of boundary 2" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 2 - II"));
		parameter Integer contactBound3=0 if Bound>2 "Boundary 3 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 3 - I"));
		parameter Real ABound3(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>2 "Surface area of boundary 3" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 3 - I"));
		parameter Real AWindow3(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>2 "Window surface area of boundary 3" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 3 - I"));
		parameter Real AOthers3(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>2 "Other surface area of boundary 3" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 3 - I"));
		parameter Real dBound3(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>2 "Thickness of boundary 3" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 3 - I"));
		parameter Real rhoBound3(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>2 "Density of boundary 3" annotation(Dialog(
			group="Material ",
			tab="Boundary 3 - I"));
		parameter Real cpBound3(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>2 "Specific heat capacity of boundary 3" annotation(Dialog(
			group="Material ",
			tab="Boundary 3 - I"));
		parameter Real uBound3(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>2 "Heat transmission value of boundary 3" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 3 - I"));
		parameter Real uWindow3(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>2 "Heat transmission value of window in boundary 3" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 3 - I"));
		parameter Real uOthers3(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>2 "Heat transmission value of other surfaces in boundary 3" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 3 - I"));
		parameter Boolean groundContact3=false if Bound>2 and not contactBound3>0 "Boundary 3 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 3 - II"));
		parameter Real depthBound3(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>2 and Ground3 "Depth of boundary 3, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 3 - II"));
		parameter Real epsDirt3=0.1 if Bound>2 "Dirt correction value for window in boundary 3 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 3 - II"));
		parameter Real epsShading3=0.2 if Bound>2 "Shading correction value for boundary 3 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 3 - II"));
		parameter Real epsFrame3=0.2 if Bound>2 "Frame correction value for window in boundary 3 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 3 - II"));
		parameter Real alphaInclination3(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>2 "Inclination angle of boundary 3" annotation(Dialog(
			group="Alignment",
			tab="Boundary 3 - II"));
		parameter Real alphaOrientation3(
			quantity="Geometry.Angle",
			displayUnit="°")=3.1415926535897931 if Bound>2 "Orientation angle of boundary 3" annotation(Dialog(
			group="Alignment",
			tab="Boundary 3 - II"));
		parameter Real gWindow3=0.6 if Bound>2 "Total translucency of window in boundary 3" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 3 - II"));
		parameter Real alphaBound3=0.2 if Bound>2 "Absorption coefficient of boundary 3" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 3 - II"));
		parameter Real alphaBoundOut3(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>2 and not Ground3 "Outer heat transmission coefficient of boundary 3" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 3 - II"));
		parameter Real alphaBoundIn3(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>2 "Inner heat transmission coefficient of boundary 3" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 3 - II"));
		parameter Integer contactBound4=0 if Bound>3 "Boundary 4 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 4 - I"));
		parameter Real ABound4(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>3 "Surface area of boundary 4" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 4 - I"));
		parameter Real AWindow4(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>3 "Window surface area of boundary 4" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 4 - I"));
		parameter Real AOthers4(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>3 "Other surface area of boundary 4" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 4 - I"));
		parameter Real dBound4(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>3 "Thickness of boundary 4" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 4 - I"));
		parameter Real rhoBound4(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>3 "Density of boundary 4" annotation(Dialog(
			group="Material",
			tab="Boundary 4 - I"));
		parameter Real cpBound4(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>3 "Specific heat capacity of boundary 4" annotation(Dialog(
			group="Material",
			tab="Boundary 4 - I"));
		parameter Real uBound4(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>3 "Heat transmission value of boundary 4" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 4 - I"));
		parameter Real uWindow4(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>3 "Heat transmission value of window in boundary 4" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 4 - I"));
		parameter Real uOthers4(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>3 "Heat transmission value of other surfaces in boundary 4" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 4 - I"));
		parameter Boolean groundContact4=false if Bound>3 and not contactBound4>0 "Boundary 4 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 4 - II"));
		parameter Real depthBound4(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>3 and Ground4 "Depth of boundary 4, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 4 - II"));
		parameter Real epsDirt4=0.1 if Bound>3 "Dirt correction value for window in boundary 4 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 4 - II"));
		parameter Real epsShading4=0.2 if Bound>3 "Shading correction value for boundary 4 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 4 - II"));
		parameter Real epsFrame4=0.2 if Bound>3 "Frame correction value for window in boundary 4 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 4 - II"));
		parameter Real alphaInclination4(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>3 "Inclination angle of boundary 4" annotation(Dialog(
			group="Alignment",
			tab="Boundary 4 - II"));
		parameter Real alphaOrientation4(
			quantity="Geometry.Angle",
			displayUnit="°")=4.7123889803846897 if Bound>3 "Orientation angle of boundary 4" annotation(Dialog(
			group="Alignment",
			tab="Boundary 4 - II"));
		parameter Real gWindow4=0.6 if Bound>3 "Total translucency of window in boundary 4" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 4 - II"));
		parameter Real alphaBound4=0.2 if Bound>3 "Absorption coefficient of boundary 4" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 4 - II"));
		parameter Real alphaBoundOut4(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>3 and not Ground4 "Outer heat transmission coefficient of boundary 4" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 4 - II"));
		parameter Real alphaBoundIn4(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>3 "Inner heat transmission coefficient of boundary 4" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 4 - II"));
		parameter Integer contactBound5=0 if Bound>4 "Boundary 5 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 5 - I"));
		parameter Real ABound5(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>4 "Surface area of boundary 5" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 5 - I"));
		parameter Real AWindow5(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>4 "Window surface area of boundary 5" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 5 - I"));
		parameter Real AOthers5(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>4 "Other surface area of boundary 5" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 5 - I"));
		parameter Real dBound5(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>4 "Thickness of boundary 5" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 5 - I"));
		parameter Real rhoBound5(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>4 "Density of boundary 5" annotation(Dialog(
			group="Material",
			tab="Boundary 5 - I"));
		parameter Real cpBound5(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>4 "Specific heat capacity of boundary 5" annotation(Dialog(
			group="Material",
			tab="Boundary 5 - I"));
		parameter Real uBound5(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>4 "Heat transmission value of boundary 5" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 5 - I"));
		parameter Real uWindow5(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>4 "Heat transmission value of window in boundary 5" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 5 - I"));
		parameter Real uOthers5(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>4 "Heat transmission value of other surfaces in boundary 5" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 5 - I"));
		parameter Boolean groundContact5=true if Bound>4 and not contactBound5>0 "Boundary 5 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 5 - II"));
		parameter Real depthBound5(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>4 and Ground5 "Depth of boundary 5, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 5 - II"));
		parameter Real epsDirt5=0 if Bound>4 "Dirt correction value for window in boundary 5 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 5 - II"));
		parameter Real epsShading5=1 if Bound>4 "Shading correction value for boundary 5 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 5 - II"));
		parameter Real epsFrame5=0 if Bound>4 "Frame correction value for window in boundary 5 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 5 - II"));
		parameter Real alphaInclination5(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>4 "Inclination angle of boundary 5" annotation(Dialog(
			group="Alignment",
			tab="Boundary 5 - II"));
		parameter Real alphaOrientation5(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>4 "Orientation angle of boundary 5" annotation(Dialog(
			group="Alignment",
			tab="Boundary 5 - II"));
		parameter Real gWindow5=0.6 if Bound>4 "Total translucency of window in boundary 5" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 5 - II"));
		parameter Real alphaBound5=0 if Bound>4 "Absorption coefficient of boundary 5" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 5 - II"));
		parameter Real alphaBoundOut5(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>4 and not Ground5 "Outer heat transmission coefficient of boundary 5" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 5 - II"));
		parameter Real alphaBoundIn5(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>4 "Inner heat transmission coefficient of boundary 5" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 5 - II"));
		parameter Integer contactBound6=0 if Bound>5 "Boundary 6 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 6 - I"));
		parameter Real ABound6(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>5 "Surface area of boundary 6" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 6 - I"));
		parameter Real AWindow6(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>5 "Window surface area of boundary 6" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 6 - I"));
		parameter Real AOthers6(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>5 "Other surface area of boundary 6" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 6 - I"));
		parameter Real dBound6(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>5 "Thickness of boundary 6" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 6 - I"));
		parameter Real rhoBound6(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>5 "Density of boundary 6" annotation(Dialog(
			group="Material",
			tab="Boundary 6 - I"));
		parameter Real cpBound6(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>5 "Specific heat capacity of boundary 6" annotation(Dialog(
			group="Material",
			tab="Boundary 6 - I"));
		parameter Real uBound6(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>5 "Heat transmission value of boundary 6" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 6 - I"));
		parameter Real uWindow6(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>5 "Heat transmission value of window in boundary 6" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 6 - I"));
		parameter Real uOthers6(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>5 "Heat transmission value of other surfaces in boundary 6" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 6 - I"));
		parameter Boolean groundContact6=false if Bound>5 and not contactBound6>0 "Boundary 6 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 6 - II"));
		parameter Real depthBound6(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>5 and Ground6 "Depth of boundary 6, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 6 - II"));
		parameter Real epsDirt6=0.1 if Bound>5 "Dirt correction value for window in boundary 6 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 6 - II"));
		parameter Real epsShading6=0.2 if Bound>5 "Shading correction value for boundary 6 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 6 - II"));
		parameter Real epsFrame6=0.2 if Bound>5 "Frame correction value for window in boundary 6 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 6 - II"));
		GreenBuilding.Interfaces.Thermal.VolumeFlowIn HeatFlow if not LoadCalculation and Heat "Flow pipe" annotation(Placement(
			transformation(extent={{310,-470},{330,-450}}),
			iconTransformation(extent={{-360,40},{-340,60}})));
		GreenBuilding.Interfaces.Thermal.VolumeFlowOut HeatReturn if not LoadCalculation and Heat "Return pipe" annotation(Placement(
			transformation(extent={{310,-515},{330,-495}}),
			iconTransformation(extent={{-360,-60},{-340,-40}})));
		GreenBuilding.Interfaces.ZoneTemperature.ZoneTemperatures ZoneTemperatures[min(max(NumberZones,1),MaxNumberZones)] if(contactBound1>0) or (contactBound2>0 and Bound>1) or (contactBound3>0 and Bound>2) or (contactBound4>0 and Bound>3) or (contactBound5>0 and Bound>4) or (contactBound6>0 and Bound>5) or (contactBound7>0 and Bound>6) or (contactBound8>0 and Bound>7) or (contactBound9>0 and Bound>8) "Temperatures of building zones" annotation(Placement(
			transformation(extent={{605,-590},{625,-570}}),
			iconTransformation(extent={{340,-110},{360,-90}})));
		GreenBuilding.Interfaces.Ambience.AmbientCondition AmbientConditions "Ambient Conditions Connection" annotation(Placement(
			transformation(extent={{605,-450},{625,-430}}),
			iconTransformation(extent={{340,90},{360,110}})));
		parameter Real alphaInclination6(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>5 "Inclination angle of boundary 6" annotation(Dialog(
			group="Alignment",
			tab="Boundary 6 - II"));
	protected
		function calc_Phi
			input Real P;
			input Real Q;
			output Real Phi;
			protected
				Real P_act;
			algorithm
				if (P>1e-10) then
					P_act:=P;
				elseif (P<-1e-10) then
					P_act:=P;
				else	
					P_act:=(1e-10)*sign(P);
				end if;
				if ((abs(P_act)>1e-10) and (abs(Q)>1e-10)) then
					if (P_act>=0) then
						Phi:=atan(Q/P_act);
					else
						if (Q>0) then
							Phi:=pi+atan(Q/P_act);
						else
							Phi:=-pi+atan(Q/P_act);
						end if;
					end if;
				else
					if (abs(Q)>1e-10) then
						if (Q>0) then
							Phi:=pi/2;
						else
							Phi:=-pi/2;
						end if;
					else
						if (P_act>=0) then	
							Phi:=0;
						else
							Phi:=-pi;
						end if;
					end if;
				end if;
			annotation(Impure=false);
		end calc_Phi;
		function calc_current
			input Real P;
			input Real U;
			output Real current;
			protected
				Real S;
			algorithm
				S:=(P^2)^0.5;
				if (abs(U)>1e-10) then
					current:=S/U;
				else
					current:=0;
				end if;
			annotation(Impure=false);
		end calc_current;
		function ground
			input Real depthGround;
			input Real DayOfYear;
			input Boolean LeapYear;
			input Real cGround;
			input Real lambdaGround;
			input Real rhoGround;
			input Real GeoGradient;
			input Real TAmbientAverage;
			input Real TAmbientMax;
			input Integer MaxMonth;
			output Real TGround;
			protected
				Real a=lambdaGround/(rhoGround*cGround);
				Real xi;
				Real TimePeriod;
				Real PhaseDisplacement=2*pi*MaxMonth/12;
			algorithm
				if (LeapYear) then
					TimePeriod:=366*24*3600;
				else
					TimePeriod:=365*24*3600;
				end if;
				xi:=depthGround*sqrt(pi/(a*TimePeriod));
				TGround:=TAmbientAverage+GeoGradient*depthGround+(((TAmbientMax-TAmbientAverage)*exp(-xi)))*cos(2*pi*(DayOfYear*24*3600)/TimePeriod-PhaseDisplacement-xi);
			annotation(
				Impure=false,
				derivative=groundDot);
		end ground;
		function groundDot
			input Real depthGround;
			input Real DayOfYear;
			input Boolean LeapYear;
			input Real cGround;
			input Real lambdaGround;
			input Real rhoGround;
			input Real GeoGradient;
			input Real TAmbientAverage;
			input Real TAmbientMax;
			input Integer MaxMonth;
			input Real depthGroundDot;
			input Real DayOfYearDot;
			input Real cGroundDot;
			input Real lambdaGroundDot;
			input Real rhoGroundDot;
			input Real GeoGradientDot;
			input Real TAmbientAverageDot;
			input Real TAmbientMaxDot;
			output Real TGroundDot;
			protected
				Real a:=lambdaGround/(rhoGround*cGround);
				Real xi;
				Real TimePeriod;
				Real PhaseDisplacement:=2*pi*MaxMonth/12;
				Real aDot=0;
				Real xiDot=0;
				Real TimePeriodDot=0;
				Real PhaseDisplacementDot=0;
			algorithm
				if (LeapYear) then
					TimePeriod:=366*24*3600;
				else
					TimePeriod:=365*24*3600;
				end if;
				xi:=depthGround*sqrt(pi/(a*TimePeriod));
				
				TGroundDot:=(((TAmbientMax-TAmbientAverage)*exp(-xi)))*-(2*pi*24*3600*DayOfYearDot/TimePeriod)*sin(2*pi*(DayOfYear*24*3600)/TimePeriod-PhaseDisplacement-xi);
			annotation(Impure=false);
		end groundDot;
		function angleMinMax
			input Real angle;
			input Real angleMax;
			input Real angleMin;
			output Real angleOut;
			algorithm
				angleOut:=min(angleMax,(max(angleMin,angle)));
			annotation(Impure=false);
		end angleMinMax;
		function ThreeVectorMult
			input Real vector1[:];
			input Real vector2[:];
			input Real vector3[:];
			input Integer length;
			output Real prod;
			algorithm
				prod:=0;
				for i in 1:length loop
					prod:=prod+(vector1[i]*vector2[i]*vector3[i]);
				end for;
			annotation(Impure=false);
		end ThreeVectorMult;
		function sumVector
			input Real u[:];
			input Integer first;
			input Integer last;
			output Real y;
			algorithm
				y:=0;
				for i in first:last loop
					y:=y+u[i];
				end for;
			annotation(Impure=false);
		end sumVector;
		function sumVector1
			input Real u[:];
			input Real v[:];
			input Integer first;
			input Integer last;
			output Real y;
			algorithm
				y:=0;
				for i in first:last loop
					if (v[i]>1e-3) then
						y:=y+u[i];
					else
						y:=y+0;
					end if;
				end for;
			annotation(Impure=false);
		end sumVector1;
		function sumVector2
			input Real u[:];
			input Real v[:];
			input Integer first;
			input Integer last;
			output Real y;
			algorithm
				y:=0;
				for i in first:last loop
					if not(v[i]>1e-3) then
						y:=y+u[i];
					else
						y:=y+0;
					end if;
				end for;
			annotation(Impure=false);
		end sumVector2;
		function normalVector
			input Real alphaInclination;
			input Real alphaOrientation;
			output Real vector[3];
			algorithm
				vector[1]:=sin(alphaInclination)*cos(alphaOrientation);
				vector[2]:=sin(alphaInclination)*sin(alphaOrientation);
				vector[3]:=cos(alphaInclination);
			annotation(Impure=false);
		end normalVector;
		function diffAngle
			input Real vector1[3];
			input Real vector2[3];
			output Real angle;
			protected
				Real value;
				Real minMax;
			algorithm
				value:=(vector1[1]*vector2[1]+vector1[2]*vector2[2]+vector1[3]*vector2[3])/(sqrt(vector1[1]*vector1[1]+vector1[2]*vector1[2]+vector1[3]*vector1[3])*sqrt(vector2[1]*vector2[1]+vector2[2]*vector2[2]+vector2[3]*vector2[3]));
				minMax:=max(min(value,1),-1);
				angle:=acos(minMax);
			annotation(Impure=false);
		end diffAngle;
	public
		parameter Real alphaOrientation6(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>5 "Orientation angle of boundary 6" annotation(Dialog(
			group="Alignment",
			tab="Boundary 6 - II"));
		parameter Real gWindow6=0.6 if Bound>5 "Total translucency of window in boundary 6" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 6 - II"));
		parameter Real alphaBound6=0.5 if Bound>5 "Absorption coefficient of boundary 6" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 6 - II"));
		parameter Real alphaBoundOut6(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>5 and not Ground6 "Outer heat transmission coefficient of boundary 6" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 6 - II"));
		parameter Real alphaBoundIn6(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>5 "Inner heat transmission coefficient of boundary 6" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 6 - II"));
		parameter Integer contactBound7=0 if Bound>6 "Boundary 7 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 7 - I"));
		parameter Real ABound7(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>6 "Surface area of boundary 7" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 7 - I"));
		parameter Real AWindow7(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>6 "Window surface area of boundary 7" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 7 - I"));
		parameter Real AOthers7(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>6 "Other surface area of boundary 7" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 7 - I"));
		parameter Real dBound7(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>6 "Thickness of boundary 7" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 7 - I"));
		parameter Real rhoBound7(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>6 "Density of boundary 7" annotation(Dialog(
			group="Material",
			tab="Boundary 7 - I"));
		parameter Real cpBound7(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>6 "Specific heat capacity of boundary 7" annotation(Dialog(
			group="Material",
			tab="Boundary 7 - I"));
		parameter Real uBound7(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>6 "Heat transmission value of boundary 7" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 7 - I"));
		parameter Real uWindow7(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>6 "Heat transmission value of window in boundary 7" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 7 - I"));
		parameter Real uOthers7(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>6 "Heat transmission value of other surfaces in boundary 7" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 7 - I"));
		parameter Boolean groundContact7=false if Bound>6 and not contactBound7>0 "Boundary 7 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 7 - II"));
		parameter Real depthBound7(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>6 and Ground7 "Depth of boundary 7, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 7 - II"));
		parameter Real epsDirt7=0.1 if Bound>6 "Dirt correction value for window in boundary 7 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 7 - II"));
		parameter Real epsShading7=0.2 if Bound>6 "Shading correction value for boundary 7 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 7 - II"));
		parameter Real epsFrame7=0.2 if Bound>6 "Frame correction value for window in boundary 7 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 7 - II"));
		parameter Real alphaInclination7(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>6 "Inclination angle of boundary 7" annotation(Dialog(
			group="Alignment",
			tab="Boundary 7 - II"));
		parameter Real alphaOrientation7(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>6 "Orientation angle of boundary 7" annotation(Dialog(
			group="Alignment",
			tab="Boundary 7 - II"));
		parameter Real gWindow7=0.6 if Bound>6 "Total translucency of window in boundary 7" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 7 - II"));
		parameter Real alphaBound7=0.2 if Bound>6 "Absorption coefficient of boundary 7" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 7 - II"));
		parameter Real alphaBoundOut7(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>6 and not Ground7 "Outer heat transmission coefficient of boundary 7" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 7 - II"));
		parameter Real alphaBoundIn7(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>6 "Inner heat transmission coefficient of boundary 7" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 7 - II"));
		parameter Integer contactBound8=0 if Bound>7 "Boundary 8 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 8 - I"));
		parameter Real ABound8(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>7 "Surface area of boundary 8" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 8 - I"));
		parameter Real AWindow8(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>7 "Window surface area of boundary 8" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 8 - I"));
		parameter Real AOthers8(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>7 "Other surface area of boundary 8" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 8 - I"));
		parameter Real dBound8(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>7 "Thickness of boundary 8" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 8 - I"));
		parameter Real rhoBound8(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>7 "Density of boundary 8" annotation(Dialog(
			group="Material",
			tab="Boundary 8 - I"));
		parameter Real cpBound8(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>7 "Specific heat capacity of boundary 8" annotation(Dialog(
			group="Material",
			tab="Boundary 8 - I"));
		parameter Real uBound8(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>7 "Heat transmission value of boundary 8" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 8 - I"));
		parameter Real uWindow8(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>7 "Heat transmission value of window in boundary 8" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 8 - I"));
		parameter Real uOthers8(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>7 "Heat transmission value of other surfaces in boundary 8" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 8 - I"));
		parameter Boolean groundContact8=false if Bound>7 and not contactBound8>0 "Boundary 8 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 8 - II"));
		parameter Real depthBound8(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>7 and Ground8 "Depth of boundary 8, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 8 - II"));
		parameter Real epsDirt8=0.1 if Bound>7 "Dirt correction value for window in boundary 8 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 8 - II"));
		parameter Real epsShading8=0.2 if Bound>7 "shading correction value for  Boundary 8 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 8 - II"));
		parameter Real epsFrame8=0.2 if Bound>7 "Frame correction value for window in boundary 8 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 8 - II"));
		parameter Real alphaInclination8(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>7 "Inclination angle of boundary 8" annotation(Dialog(
			group="Alignment",
			tab="Boundary 8 - II"));
		parameter Real alphaOrientation8(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>7 "Orientation angle of boundary 8" annotation(Dialog(
			group="Alignment",
			tab="Boundary 8 - II"));
		parameter Real gWindow8=0.6 if Bound>7 "Total translucency of window in boundary 8" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 8 - II"));
		parameter Real alphaBound8=0.2 if Bound>7 "Absorption coefficient of boundary 8" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 8 - II"));
		parameter Real alphaBoundOut8(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>7 and not Ground8 "Outer heat transmission coefficient of boundary 8" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 8 - II"));
		parameter Real alphaBoundIn8(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>7 "Inner heat transmission coefficient of boundary 8" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 8 - II"));
		parameter Integer contactBound9=0 if Bound>8 "Boundary 9 is connected to: '0'-Ambience, '1,2,3 ...-Zone 1,2,3 ..." annotation(Dialog(
			group="Ambience",
			tab="Boundary 9 - I"));
		parameter Real ABound9(
			quantity="Geometry.Area",
			displayUnit="m²")=30 if Bound>8 "Surface area of boundary 9" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 9 - I"));
		parameter Real AWindow9(
			quantity="Geometry.Area",
			displayUnit="m²")=5 if Bound>8 "Window surface area of boundary 9" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 9 - I"));
		parameter Real AOthers9(
			quantity="Geometry.Area",
			displayUnit="m²")=0 if Bound>8 "Other surface area of boundary 9" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 9 - I"));
		parameter Real dBound9(
			quantity="Geometry.Length",
			displayUnit="m")=0.36 if Bound>8 "Thickness of boundary 9" annotation(Dialog(
			group="Dimensions",
			tab="Boundary 9 - I"));
		parameter Real rhoBound9(
			quantity="Thermics.Density",
			displayUnit="kg/m³")=1800 if Bound>8 "Density of boundary 9" annotation(Dialog(
			group="Material",
			tab="Boundary 9 - I"));
		parameter Real cpBound9(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=920 if Bound>8 "Specific heat capacity of boundary 9" annotation(Dialog(
			group="Material",
			tab="Boundary 9 - I"));
		parameter Real uBound9(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0.2 if Bound>8 "Heat transmission value of boundary 9" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 9 - I"));
		parameter Real uWindow9(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=1 if Bound>8 "Heat transmission value of window in boundary 9" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 9 - I"));
		parameter Real uOthers9(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=0 if Bound>8 "Heat transmission value of other surfaces in boundary 9" annotation(Dialog(
			group="Heat Transmission",
			tab="Boundary 9 - I"));
		parameter Boolean groundContact9=false if Bound>8 and not contactBound9>0 "Boundary 9 has contact to ground" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 9 - II"));
		parameter Real depthBound9(
			quantity="Geometry.Length",
			displayUnit="m")=1 if Bound>8 and Ground9 "Depth of boundary 9, if it is ground contacted" annotation(Dialog(
			group="Ground Position",
			tab="Boundary 9 - II"));
		parameter Real epsDirt9=0.1 if Bound>8 "Dirt correction value for window in boundary 9 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 9 - II"));
		parameter Real epsShading9=0.2 if Bound>8 "Shading correction value for boundary 9 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 9 - II"));
		parameter Real epsFrame9=0.2 if Bound>8 "Frame correction value for window in boundary 9 (0: fully irradiated, 1: fully shaded)" annotation(Dialog(
			group="Correction Values",
			tab="Boundary 9 - II"));
		parameter Real alphaInclination9(
			quantity="Geometry.Angle",
			displayUnit="°")=1.5707963267948966 if Bound>8 "Inclination angle of boundary 9" annotation(Dialog(
			group="Alignment",
			tab="Boundary 9 - II"));
		parameter Real alphaOrientation9(
			quantity="Geometry.Angle",
			displayUnit="°")=0 if Bound>8 "Orientation angle of boundary 9" annotation(Dialog(
			group="Alignment",
			tab="Boundary 9 - II"));
		parameter Real gWindow9=0.6 if Bound>8 "Total translucency of window in boundary 9" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 9 - II"));
		parameter Real alphaBound9=0.2 if Bound>8 "Absorption coefficient of boundary 9" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 9 - II"));
		parameter Real alphaBoundOut9(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=20 if Bound>8 and not Ground9 "Outer heat transmission coefficient of boundary 9" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 9 - II"));
		parameter Real alphaBoundIn9(
			quantity="Thermics.HeatTransmCoeff",
			displayUnit="W/(m²·K)")=7.5 if Bound>8 "Inner heat transmission coefficient of boundary 9" annotation(Dialog(
			group="Heat Absorption",
			tab="Boundary 9 - II"));
	protected
		model Boundary "Properties of a boundary V1.0"
			Real ABound(
				quantity="Geometry.Area",
				displayUnit="m²") "Surface area";
			Real AWindow(
				quantity="Geometry.Area",
				displayUnit="m²") "Window surface area";
			Real AOthers(
				quantity="Geometry.Area",
				displayUnit="m²") "Other surfaces (e.g. doors)";
			Real rhoBound(
				quantity="Thermodynamics.Density",
				displayUnit="kg/m³") "Density of boundary";
			Real cpBound(
				quantity="Thermodynamics.SpecHeatCapacity",
				displayUnit="kJ/(kg·K)") "Specific heat capacity of boundary";
			Real dBound(
				quantity="Geometry.Length",
				displayUnit="m") "Thickness of boundary";
			Real gWindow "Total energy translucency of window";
			Real uBound(
				quantity="Thermics.HeatTransmCoeff",
				displayUnit="W/(m²·K)") "Heat transmission value of boundary";
			Real uWindow(
				quantity="Thermics.HeatTransmCoeff",
				displayUnit="W/(m²·K)") "Heat transmission value of window";
			Real uOthers(
				quantity="Thermics.HeatTransmCoeff",
				displayUnit="W/(m²·K)") "Heat transmission value of other surfaces";
			Real epsDirt "Dirt corrction value for window";
			Real epsShading "Shading correction value for window";
			Real epsFrame "Frame correction value for window";
			Real NormalVector[3] "Normal vector of boundary";
			Real alphaInc "Inclination angle of boundary";
			Real alphaOr "Orientation angle of boundary";
			Real alphaBound "Absorption coefficient of boundary";
			Real alphaBoundOut(
				quantity="Thermics.HeatTransmCoeff",
				displayUnit="W/(m²·K)") "Outer heat transmission coefficient of boundary";
			Real alphaBoundIn(
				quantity="Thermics.HeatTransmCoeff",
				displayUnit="W/(m²·K)") "Inner heat transmission coefficient of boundary";
			Real depthBound(
				quantity="Geometry.Length",
				displayUnit="m") "Depth of boundary, if it is ground connected";
			Integer contactBound "Boundary is connected to: '0' - ambience, 1,2,3 ... - Zone 1,2,3";
			Real TBoundIn(
				quantity="Thermics.Temp",
				displayUnit="°C") "Average inner boundary temperature";
			Real TBoundOut(
				quantity="Thermics.Temp",
				displayUnit="°C") "Average outer boundary temperature";
			Real TGround(
				quantity="Thermics.Temp",
				displayUnit="°C") "Ground temperature, if boundary is ground connected";
			Real lambdaBound(
				quantity="Thermics.SpecHeatCond",
				displayUnit="W/(m·K)") "Heat conductance of boundary";
			Boolean groundContact "Boundary ground contact enabled/disabled";
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end Boundary;
		model InnerMass "Properties of an inner Mass V1.0"
			Real V(
				quantity="Geometry.Volume",
				displayUnit="m³") "Inner additional volumes (e.g. inner walls)";
			Real rho(
				quantity="Thermics.Density",
				displayUnit="kg/m³") "Density";
			Real cp(
				quantity="Thermics.SpecHeatCapacity",
				displayUnit="kJ/(kg·K)") "Specific heat capacity";
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end InnerMass;
	initial equation
		assert((Bound>=BoundMin), "Number of Boundaries is too low");
		assert((Bound<=BoundMax), "Number of Boundaries is too high");
		assert((Mass>=MassMin), "Number of inner Masses is too low");
		assert((Mass<=MassMax), "Number of inner Masses is too high");
		assert(NumberZones>=1 and NumberZones<=MaxNumberZones, "Number of Zones out of limits");
		assert(ZoneIndex>=1 and ZoneIndex<=MaxNumberZones, "Zone index out of limits");
		if (LoadCalculation) then
			TZoneAct=TZoneRef;
		else
			TZoneAct=TZoneInit;
		end if;
		if not LoadCalculation and Heat then
			TReturnHeat=TReturnHeatInit;
		else
			TReturnHeat=0;
		end if;
				
		EHeat=0;
		Eel=0;
	algorithm
		when(initial()) then
			for i in 1:Bound loop
				if (Boundaries[i].contactBound>0 or Boundaries[i].groundContact) then
					if (Boundaries[i].lambdaBound>1e-10) then
						reinit(deltaTBound[i],(TZoneAct-TAmbientBound[i])*(Boundaries[i].uBound)/(Boundaries[i].lambdaBound/Boundaries[i].dBound));
					else
						reinit(deltaTBound[i],TZoneAct-TAmbientBound[i]);
					end if;
					if (Boundaries[i].groundContact) then
						reinit(Boundaries[i].TBoundOut,TAmbientBound[i]);
					else
						reinit(Boundaries[i].TBoundOut,TAmbientBound[i]+((TZoneAct-TAmbientBound[i])-deltaTBound[i])/2);
					end if;				
						reinit(Boundaries[i].TBoundIn,TZoneAct-((TZoneAct-TAmbientBound[i])-deltaTBound[i])/2);	
					else
					if (Boundaries[i].lambdaBound>1e-10) then
						reinit(deltaTBound[i],(TZoneAct-AmbientConditions.TAmbientAverageAct)*(Boundaries[i].uBound)/(Boundaries[i].lambdaBound/Boundaries[i].dBound));
					else
						reinit(deltaTBound[i],TZoneAct-AmbientConditions.TAmbientAverageAct);
					end if;
					reinit(Boundaries[i].TBoundIn,TZoneAct-((TZoneAct-AmbientConditions.TAmbientAverageAct)-deltaTBound[i])/2);
					reinit(Boundaries[i].TBoundOut,AmbientConditions.TAmbientAverageAct+((TZoneAct-AmbientConditions.TAmbientAverageAct)-deltaTBound[i])/2);
				end if;
			end for;
		end when;
	equation
			if (Mass>0) then
				for i in 1:Mass loop
					if (i==1) then
						Masses[1].cp=cpMass1;
						Masses[1].rho=rhoMass1;
						Masses[1].V=VMass1;
					elseif (i==2) then
						Masses[2].cp=cpMass2;
						Masses[2].rho=rhoMass2;
						Masses[2].V=VMass2;
					elseif (i==3) then
						Masses[3].cp=cpMass3;
						Masses[3].rho=rhoMass3;
						Masses[3].V=VMass3;
					else
						Masses[4].cp=cpMass4;
						Masses[4].rho=rhoMass4;
						Masses[4].V=VMass4;
					end if;
				end for;
			end if;
			for i in 1:Bound loop
				if (i==1) then
					assert(uBound1>1e-10,"Boundary 1 - uBound=0");
					assert(alphaBoundIn1>1e-10,"Boundary 1 - alphaBoundIn=0");
					assert(contactBound1>=0 or contactBound1<=NumberZones,"contactBound1 out of bounds");
					assert(alphaInclination1>=0 and alphaInclination1<=pi,"alphaInclination1 must be within 0° and 180°");
					assert(alphaOrientation1>=0 and alphaOrientation1<=2*pi,"alphaOrientation1 must be within 0° and 360°");
					if not contactBound1>0 then	
						Boundaries[1].groundContact=groundContact1;
					else
						Boundaries[1].groundContact=false;
					end if;
					Boundaries[1].ABound=ABound1;
					Boundaries[1].AWindow=AWindow1;
					Boundaries[1].AOthers=AOthers1;
					Boundaries[1].rhoBound=rhoBound1;
					Boundaries[1].cpBound=cpBound1;
					Boundaries[1].dBound=dBound1;
					Boundaries[1].gWindow=gWindow1;
					Boundaries[1].uBound=uBound1;
					Boundaries[1].uWindow=uWindow1;
					Boundaries[1].uOthers=uOthers1;
					Boundaries[1].epsDirt=epsDirt1;
					Boundaries[1].epsShading=epsShading1;
					Boundaries[1].epsFrame=epsFrame1;
					Boundaries[1].NormalVector=normalVector(alphaInclination1,alphaOrientation1);
					Boundaries[1].alphaInc=alphaInclination1;
					Boundaries[1].alphaOr=alphaOrientation1;
					Boundaries[1].alphaBound=alphaBound1;
					Boundaries[1].contactBound=contactBound1;
					if not contactBound1>0 then	
						if (groundContact1) then
							Boundaries[1].alphaBoundOut=0;
							Boundaries[1].depthBound=depthBound1;
						else
							assert(alphaBoundOut1>1e-10,"Boundary 1 - alphaBoundOut=0");
							Boundaries[1].alphaBoundOut=alphaBoundOut1;
							Boundaries[1].depthBound=0;
						end if;
					else
						assert(alphaBoundOut1>1e-10,"Boundary 1 - alphaBoundOut=0");
						Boundaries[1].alphaBoundOut=alphaBoundOut1;
						Boundaries[1].depthBound=0;
					end if;
					Boundaries[1].alphaBoundIn=alphaBoundIn1;
					if not contactBound1>0 then
						if (groundContact1) then
							Boundaries[1].lambdaBound=(dBound1)/((1/min(uBound1,alphaBoundIn1-1e-3))-(1/alphaBoundIn1));
						else
							Boundaries[1].lambdaBound=(dBound1)/((1/min(uBound1,((alphaBoundIn1*alphaBoundOut1)/(alphaBoundIn1+alphaBoundOut1)-1e-3)))-(1/alphaBoundIn1)-(1/alphaBoundOut1));
						end if;
					else
						Boundaries[1].lambdaBound=(dBound1)/((1/min(uBound1,((alphaBoundIn1*alphaBoundOut1)/(alphaBoundIn1+alphaBoundOut1)-1e-3)))-(1/alphaBoundIn1)-(1/alphaBoundOut1));
					end if;
				elseif (i==2) then
					assert(uBound2>1e-10,"Boundary 2 - uBound=0");
					assert(alphaBoundIn2>1e-10,"Boundary 2 - alphaBoundIn=0");
					assert(contactBound2>=0 or contactBound2<=NumberZones,"contactBound2 out of bounds");
					assert(alphaInclination2>=0 and alphaInclination2<=pi,"alphaInclination2 must be within 0° and 180°");
					assert(alphaOrientation2>=0 and alphaOrientation2<=2*pi,"alphaOrientation2 must be within 0° and 360°");
					if not contactBound2>0 then	
						Boundaries[2].groundContact=groundContact2;
					else
						Boundaries[2].groundContact=false;
					end if;				
					Boundaries[2].ABound=ABound2;
					Boundaries[2].AWindow=AWindow2;
					Boundaries[2].AOthers=AOthers2;
					Boundaries[2].rhoBound=rhoBound2;
					Boundaries[2].cpBound=cpBound2;
					Boundaries[2].dBound=dBound2;
					Boundaries[2].gWindow=gWindow2;
					Boundaries[2].uBound=uBound2;
					Boundaries[2].uWindow=uWindow2;
					Boundaries[2].uOthers=uOthers2;
					Boundaries[2].epsDirt=epsDirt2;
					Boundaries[2].epsShading=epsShading2;
					Boundaries[2].epsFrame=epsFrame2;
					Boundaries[2].NormalVector=normalVector(alphaInclination2,alphaOrientation2);
					Boundaries[2].alphaInc=alphaInclination2;
					Boundaries[2].alphaOr=alphaOrientation2;					
					Boundaries[2].alphaBound=alphaBound2;
					Boundaries[2].contactBound=contactBound2;
					if not contactBound2>0 then	
						if (groundContact2) then
							Boundaries[2].alphaBoundOut=0;
							Boundaries[2].depthBound=depthBound2;
						else
							assert(alphaBoundOut2>1e-10,"Boundary 2 - alphaBoundOut=0");
							Boundaries[2].alphaBoundOut=alphaBoundOut2;
							Boundaries[2].depthBound=0;
						end if;
					else
						assert(alphaBoundOut2>1e-10,"Boundary 2 - alphaBoundOut=0");
						Boundaries[2].alphaBoundOut=alphaBoundOut2;
						Boundaries[2].depthBound=0;
					end if;	
					Boundaries[2].alphaBoundIn=alphaBoundIn2;
					if not contactBound2>0 then
						if (groundContact2) then
							Boundaries[2].lambdaBound=(dBound2)/((1/min(uBound2,alphaBoundIn2-1e-3))-(1/alphaBoundIn2));
						else
							Boundaries[2].lambdaBound=(dBound2)/((1/min(uBound2,((alphaBoundIn2*alphaBoundOut2)/(alphaBoundIn2+alphaBoundOut2)-1e-3)))-(1/alphaBoundIn2)-(1/alphaBoundOut2));
						end if;
					else
						Boundaries[2].lambdaBound=(dBound2)/((1/min(uBound2,((alphaBoundIn2*alphaBoundOut2)/(alphaBoundIn2+alphaBoundOut2)-1e-3)))-(1/alphaBoundIn2)-(1/alphaBoundOut2));
					end if;	
				elseif (i==3) then
					assert(uBound3>1e-10,"Boundary 3 - uBound=0");
					assert(alphaBoundIn3>1e-10,"Boundary 3 - alphaBoundIn=0");
					assert(contactBound3>=0 or contactBound3<=NumberZones,"contactBound3 out of bounds");
					assert(alphaInclination3>=0 and alphaInclination3<=pi,"alphaInclination3 must be within 0° and 180°");
					assert(alphaOrientation3>=0 and alphaOrientation3<=2*pi,"alphaOrientation3 must be within 0° and 360°");
					if not contactBound3>0 then
						Boundaries[3].groundContact=groundContact3;
					else
						Boundaries[3].groundContact=false;
					end if;
					Boundaries[3].ABound=ABound3;
					Boundaries[3].AWindow=AWindow3;
					Boundaries[3].AOthers=AOthers3;
					Boundaries[3].rhoBound=rhoBound3;
					Boundaries[3].cpBound=cpBound3;
					Boundaries[3].dBound=dBound3;
					Boundaries[3].gWindow=gWindow3;
					Boundaries[3].uBound=uBound3;
					Boundaries[3].uWindow=uWindow3;
					Boundaries[3].uOthers=uOthers3;
					Boundaries[3].epsDirt=epsDirt3;
					Boundaries[3].epsShading=epsShading3;
					Boundaries[3].epsFrame=epsFrame3;
					Boundaries[3].NormalVector=normalVector(alphaInclination3,alphaOrientation3);
					Boundaries[3].alphaInc=alphaInclination3;
					Boundaries[3].alphaOr=alphaOrientation3;					
					Boundaries[3].alphaBound=alphaBound3;
					Boundaries[3].contactBound=contactBound3;
					if not contactBound3>0 then
						if (groundContact3) then
							Boundaries[3].alphaBoundOut=0;
							Boundaries[3].depthBound=depthBound3;
						else
							assert(alphaBoundOut3>1e-10,"Boundary 3 - alphaBoundOut=0");
							Boundaries[3].alphaBoundOut=alphaBoundOut3;
							Boundaries[3].depthBound=0;
						end if;
					else
						assert(alphaBoundOut3>1e-10,"Boundary 3 - alphaBoundOut=0");
						Boundaries[3].alphaBoundOut=alphaBoundOut3;
						Boundaries[3].depthBound=0;
					end if;	
					Boundaries[3].alphaBoundIn=alphaBoundIn3;
					if not contactBound3>0 then
						if (groundContact3) then
							Boundaries[3].lambdaBound=(dBound3)/((1/min(uBound3,alphaBoundIn3-1e-3))-(1/alphaBoundIn3));
						else
							Boundaries[3].lambdaBound=(dBound3)/((1/min(uBound3,((alphaBoundIn3*alphaBoundOut3)/(alphaBoundIn3+alphaBoundOut3)-1e-3)))-(1/alphaBoundIn3)-(1/alphaBoundOut3));
						end if;
					else
						Boundaries[3].lambdaBound=(dBound3)/((1/min(uBound3,((alphaBoundIn3*alphaBoundOut3)/(alphaBoundIn3+alphaBoundOut3)-1e-3)))-(1/alphaBoundIn3)-(1/alphaBoundOut3));
					end if;
				elseif (i==4) then
					assert(uBound4>1e-10,"Boundary 4 - uBound=0");
					assert(alphaBoundIn4>1e-10,"Boundary 4 - alphaBoundIn=0");
					assert(contactBound4>=0 or contactBound4<=NumberZones,"contactBound4 out of bounds");
					assert(alphaInclination4>=0 and alphaInclination4<=pi,"alphaInclination4 must be within 0° and 180°");
					assert(alphaOrientation4>=0 and alphaOrientation4<=2*pi,"alphaOrientation4 must be within 0° and 360°");
					if not contactBound4>0 then
						Boundaries[4].groundContact=groundContact4;
					else
						Boundaries[4].groundContact=false;
					end if;	
					Boundaries[4].ABound=ABound4;
					Boundaries[4].AWindow=AWindow4;
					Boundaries[4].AOthers=AOthers4;
					Boundaries[4].rhoBound=rhoBound4;
					Boundaries[4].cpBound=cpBound4;
					Boundaries[4].dBound=dBound4;
					Boundaries[4].gWindow=gWindow4;
					Boundaries[4].uBound=uBound4;
					Boundaries[4].uWindow=uWindow4;
					Boundaries[4].uOthers=uOthers4;
					Boundaries[4].epsDirt=epsDirt4;
					Boundaries[4].epsShading=epsShading4;
					Boundaries[4].epsFrame=epsFrame4;
					Boundaries[4].NormalVector=normalVector(alphaInclination4,alphaOrientation4);
					Boundaries[4].alphaInc=alphaInclination4;
					Boundaries[4].alphaOr=alphaOrientation4;					
					Boundaries[4].alphaBound=alphaBound4;
					Boundaries[4].contactBound=contactBound4;
					if not contactBound4>0 then
						if (groundContact4) then
							Boundaries[4].alphaBoundOut=0;
							Boundaries[4].depthBound=depthBound4;
						else
							assert(alphaBoundOut4>1e-10,"Boundary 4 - alphaBoundOut=0");
							Boundaries[4].alphaBoundOut=alphaBoundOut4;
							Boundaries[4].depthBound=0;
						end if;
					else
						assert(alphaBoundOut4>1e-10,"Boundary 4 - alphaBoundOut=0");
						Boundaries[4].alphaBoundOut=alphaBoundOut4;
						Boundaries[4].depthBound=0;
					end if;	
					Boundaries[4].alphaBoundIn=alphaBoundIn4;
					if not contactBound4>0 then
						if (groundContact4) then
							Boundaries[4].lambdaBound=(dBound4)/((1/min(uBound4,alphaBoundIn4-1e-3))-(1/alphaBoundIn4));
						else
							Boundaries[4].lambdaBound=(dBound4)/((1/min(uBound4,((alphaBoundIn4*alphaBoundOut4)/(alphaBoundIn4+alphaBoundOut4)-1e-3)))-(1/alphaBoundIn4)-(1/alphaBoundOut4));
						end if;
					else
						Boundaries[4].lambdaBound=(dBound4)/((1/min(uBound4,((alphaBoundIn4*alphaBoundOut4)/(alphaBoundIn4+alphaBoundOut4)-1e-3)))-(1/alphaBoundIn4)-(1/alphaBoundOut4));
					end if;	
				elseif (i==5) then
					assert(uBound5>1e-10,"Boundary 5 - uBound=0");
					assert(alphaBoundIn5>1e-10,"Boundary 5 - alphaBoundIn=0");
					assert(contactBound5>=0 or contactBound5<=NumberZones,"contactBound5 out of bounds");
					assert(alphaInclination5>=0 and alphaInclination5<=pi,"alphaInclination5 must be within 0° and 180°");
					assert(alphaOrientation5>=0 and alphaOrientation5<=2*pi,"alphaOrientation5 must be within 0° and 360°");
					if not contactBound5>0 then	
						Boundaries[5].groundContact=groundContact5;
					else
						Boundaries[5].groundContact=false;
					end if;	
					Boundaries[5].ABound=ABound5;
					Boundaries[5].AWindow=AWindow5;
					Boundaries[5].AOthers=AOthers5;
					Boundaries[5].rhoBound=rhoBound5;
					Boundaries[5].cpBound=cpBound5;
					Boundaries[5].dBound=dBound5;
					Boundaries[5].gWindow=gWindow5;
					Boundaries[5].uBound=uBound5;
					Boundaries[5].uWindow=uWindow5;
					Boundaries[5].uOthers=uOthers5;
					Boundaries[5].epsDirt=epsDirt5;
					Boundaries[5].epsShading=epsShading5;
					Boundaries[5].epsFrame=epsFrame5;
					Boundaries[5].NormalVector=normalVector(alphaInclination5,alphaOrientation5);
					Boundaries[5].alphaInc=alphaInclination5;
					Boundaries[5].alphaOr=alphaOrientation5;					
					Boundaries[5].alphaBound=alphaBound5;
					Boundaries[5].contactBound=contactBound5;
					if not contactBound5>0 then
						if (groundContact5) then
							Boundaries[5].alphaBoundOut=0;
							Boundaries[5].depthBound=depthBound5;
						else
							assert(alphaBoundOut5>1e-10,"Boundary 5 - alphaBoundOut=0");
							Boundaries[5].alphaBoundOut=alphaBoundOut5;
							Boundaries[5].depthBound=0;
						end if;
					else
						assert(alphaBoundOut5>1e-10,"Boundary 5 - alphaBoundOut=0");
						Boundaries[5].alphaBoundOut=alphaBoundOut5;
						Boundaries[5].depthBound=0;
					end if;
					Boundaries[5].alphaBoundIn=alphaBoundIn5;
					if not contactBound5>0 then
						if (groundContact5) then
							Boundaries[5].lambdaBound=(dBound5)/((1/min(uBound5,alphaBoundIn5-1e-3))-(1/alphaBoundIn5));
						else
							Boundaries[5].lambdaBound=(dBound5)/((1/min(uBound5,((alphaBoundIn5*alphaBoundOut5)/(alphaBoundIn5+alphaBoundOut5)-1e-3)))-(1/alphaBoundIn5)-(1/alphaBoundOut5));
						end if;
					else
						Boundaries[5].lambdaBound=(dBound5)/((1/min(uBound5,((alphaBoundIn5*alphaBoundOut5)/(alphaBoundIn5+alphaBoundOut5)-1e-3)))-(1/alphaBoundIn5)-(1/alphaBoundOut5));
					end if;
				elseif (i==6) then
					assert(uBound6>1e-10,"Boundary 6 - uBound=0");
					assert(alphaBoundIn6>1e-10,"Boundary 6 - alphaBoundIn=0");
					assert(contactBound6>=0 or contactBound6<=NumberZones,"contactBound6 out of bounds");
					assert(alphaInclination6>=0 and alphaInclination6<=pi,"alphaInclination6 must be within 0° and 180°");
					assert(alphaOrientation6>=0 and alphaOrientation6<=2*pi,"alphaOrientation6 must be within 0° and 360°");
					if not contactBound6>0 then	
						Boundaries[6].groundContact=groundContact6;
					else
						Boundaries[6].groundContact=false;
					end if;
					Boundaries[6].ABound=ABound6;
					Boundaries[6].AWindow=AWindow6;
					Boundaries[6].AOthers=AOthers6;
					Boundaries[6].rhoBound=rhoBound6;
					Boundaries[6].cpBound=cpBound6;
					Boundaries[6].dBound=dBound6;
					Boundaries[6].gWindow=gWindow6;
					Boundaries[6].uBound=uBound6;
					Boundaries[6].uWindow=uWindow6;
					Boundaries[6].uOthers=uOthers6;
					Boundaries[6].epsDirt=epsDirt6;
					Boundaries[6].epsShading=epsShading6;
					Boundaries[6].epsFrame=epsFrame6;
					Boundaries[6].NormalVector=normalVector(alphaInclination6,alphaOrientation6);
					Boundaries[6].alphaInc=alphaInclination6;
					Boundaries[6].alphaOr=alphaOrientation6;					
					Boundaries[6].alphaBound=alphaBound6;
					Boundaries[6].contactBound=contactBound6;
					if not contactBound6>0 then	
						if (groundContact6) then
							Boundaries[6].alphaBoundOut=0;
							Boundaries[6].depthBound=depthBound6;
						else
							assert(alphaBoundOut6>1e-10,"Boundary 6 - alphaBoundOut=0");
							Boundaries[6].alphaBoundOut=alphaBoundOut6;
							Boundaries[6].depthBound=0;
						end if;
					else
						assert(alphaBoundOut6>1e-10,"Boundary 6 - alphaBoundOut=0");
						Boundaries[6].alphaBoundOut=alphaBoundOut6;
						Boundaries[6].depthBound=0;
					end if;
					Boundaries[6].alphaBoundIn=alphaBoundIn6;
					if not contactBound6>0 then
						if (groundContact6) then
							Boundaries[6].lambdaBound=(dBound6)/((1/min(uBound6,alphaBoundIn6-1e-3))-(1/alphaBoundIn6));
						else
							Boundaries[6].lambdaBound=(dBound6)/((1/min(uBound6,((alphaBoundIn6*alphaBoundOut6)/(alphaBoundIn6+alphaBoundOut6)-1e-3)))-(1/alphaBoundIn6)-(1/alphaBoundOut6));
						end if;
					else
						Boundaries[6].lambdaBound=(dBound6)/((1/min(uBound6,((alphaBoundIn6*alphaBoundOut6)/(alphaBoundIn6+alphaBoundOut6)-1e-3)))-(1/alphaBoundIn6)-(1/alphaBoundOut6));
					end if; 	
				elseif (i==7) then
					assert(uBound7>1e-10,"Boundary 7 - uBound=0");
					assert(alphaBoundIn7>1e-10,"Boundary 7 - alphaBoundIn=0");
					assert(contactBound7>=0 or contactBound7<=NumberZones,"contactBound7 out of bounds");
					assert(alphaInclination7>=0 and alphaInclination7<=pi,"alphaInclination7 must be within 0° and 180°");
					assert(alphaOrientation7>=0 and alphaOrientation7<=2*pi,"alphaOrientation7 must be within 0° and 360°");
					if not contactBound7>0 then
						Boundaries[7].groundContact=groundContact7;
					else
						Boundaries[7].groundContact=false;
					end if;	
					Boundaries[7].ABound=ABound7;
					Boundaries[7].AWindow=AWindow7;
					Boundaries[7].AOthers=AOthers7;
					Boundaries[7].rhoBound=rhoBound7;
					Boundaries[7].cpBound=cpBound7;
					Boundaries[7].dBound=dBound7;
					Boundaries[7].gWindow=gWindow7;
					Boundaries[7].uBound=uBound7;
					Boundaries[7].uWindow=uWindow7;
					Boundaries[7].uOthers=uOthers7;
					Boundaries[7].epsDirt=epsDirt7;
					Boundaries[7].epsShading=epsShading7;
					Boundaries[7].epsFrame=epsFrame7;
					Boundaries[7].NormalVector=normalVector(alphaInclination7,alphaOrientation7);
					Boundaries[7].alphaInc=alphaInclination7;
					Boundaries[7].alphaOr=alphaOrientation7;					
					Boundaries[7].alphaBound=alphaBound7;
					Boundaries[7].contactBound=contactBound7;
					if not contactBound7>0 then
						if (groundContact7) then
							Boundaries[7].alphaBoundOut=0;
							Boundaries[7].depthBound=depthBound7;
						else
							assert(alphaBoundOut7>1e-10,"Boundary 7 - alphaBoundOut=0");
							Boundaries[7].alphaBoundOut=alphaBoundOut7;
							Boundaries[7].depthBound=0;
						end if;
					else
						assert(alphaBoundOut7>1e-10,"Boundary 7 - alphaBoundOut=0");
						Boundaries[7].alphaBoundOut=alphaBoundOut7;
						Boundaries[7].depthBound=0;
					end if;					
					Boundaries[7].alphaBoundIn=alphaBoundIn7;
					if not contactBound7>0 then
						if (groundContact7) then
							Boundaries[7].lambdaBound=(dBound7)/((1/min(uBound7,alphaBoundIn7-1e-3))-(1/alphaBoundIn7));
						else
							Boundaries[7].lambdaBound=(dBound7)/((1/min(uBound7,((alphaBoundIn7*alphaBoundOut7)/(alphaBoundIn7+alphaBoundOut7)-1e-3)))-(1/alphaBoundIn7)-(1/alphaBoundOut7));
						end if;
					else
						Boundaries[7].lambdaBound=(dBound7)/((1/min(uBound7,((alphaBoundIn7*alphaBoundOut7)/(alphaBoundIn7+alphaBoundOut7)-1e-3)))-(1/alphaBoundIn7)-(1/alphaBoundOut7));
					end if;
				elseif (i==8) then
					assert(uBound8>1e-10,"Boundary 8 - uBound=0");
					assert(alphaBoundIn8>1e-10,"Boundary 8 - alphaBoundIn=0");
					assert(contactBound8>=0 or contactBound8<=NumberZones,"contactBound8 out of bounds");
					assert(alphaInclination8>=0 and alphaInclination8<=pi,"alphaInclination8 must be within 0° and 180°");
					assert(alphaOrientation8>=0 and alphaOrientation8<=2*pi,"alphaOrientation8 must be within 0° and 360°");
					if not contactBound8>0 then	
						Boundaries[8].groundContact=groundContact8;
					else	
						Boundaries[8].groundContact=false;
					end if;	
					Boundaries[8].ABound=ABound8;
					Boundaries[8].AWindow=AWindow8;
					Boundaries[8].AOthers=AOthers8;
					Boundaries[8].rhoBound=rhoBound8;
					Boundaries[8].cpBound=cpBound8;
					Boundaries[8].dBound=dBound8;
					Boundaries[8].gWindow=gWindow8;
					Boundaries[8].uBound=uBound8;
					Boundaries[8].uWindow=uWindow8;
					Boundaries[8].uOthers=uOthers8;
					Boundaries[8].epsDirt=epsDirt8;
					Boundaries[8].epsShading=epsShading8;
					Boundaries[8].epsFrame=epsFrame8;
					Boundaries[8].NormalVector=normalVector(alphaInclination8,alphaOrientation8);
					Boundaries[8].alphaInc=alphaInclination8;
					Boundaries[8].alphaOr=alphaOrientation8;					
					Boundaries[8].alphaBound=alphaBound8;
					Boundaries[8].contactBound=contactBound8;
					if not contactBound8>0 then
						if (groundContact8) then
							Boundaries[8].alphaBoundOut=0;
							Boundaries[8].depthBound=depthBound8;
						else
							assert(alphaBoundOut8>1e-10,"Boundary 8 - alphaBoundOut=0");
							Boundaries[8].alphaBoundOut=alphaBoundOut8;
							Boundaries[8].depthBound=0;
						end if;
					else
						assert(alphaBoundOut8>1e-10,"Boundary 8 - alphaBoundOut=0");
						Boundaries[8].alphaBoundOut=alphaBoundOut8;
						Boundaries[8].depthBound=0;
					end if;			
					Boundaries[8].alphaBoundIn=alphaBoundIn8;
					if not contactBound8>0 then
						if (groundContact8) then
							Boundaries[8].lambdaBound=(dBound8)/((1/min(uBound8,alphaBoundIn8-1e-3))-(1/alphaBoundIn8));
						else
							Boundaries[8].lambdaBound=(dBound8)/((1/min(uBound8,((alphaBoundIn8*alphaBoundOut8)/(alphaBoundIn8+alphaBoundOut8)-1e-3)))-(1/alphaBoundIn8)-(1/alphaBoundOut8));
						end if;
					else
						Boundaries[8].lambdaBound=(dBound8)/((1/min(uBound8,((alphaBoundIn8*alphaBoundOut8)/(alphaBoundIn8+alphaBoundOut8)-1e-3)))-(1/alphaBoundIn8)-(1/alphaBoundOut8));
					end if;	
				else
					assert(uBound9>1e-10,"Boundary 9 - uBound=0");
					assert(alphaBoundIn9>1e-10,"Boundary 9 - alphaBoundIn=0");
					assert(contactBound9>=0 or contactBound9<=NumberZones,"contactBound9 out of bounds");
					assert(alphaInclination9>=0 and alphaInclination9<=pi,"alphaInclination9 must be within 0° and 180°");
					assert(alphaOrientation9>=0 and alphaOrientation9<=2*pi,"alphaOrientation9 must be within 0° and 360°");
					if not contactBound9>0 then	
						Boundaries[9].groundContact=groundContact9;
					else
						Boundaries[9].groundContact=false;
					end if;	
					Boundaries[9].ABound=ABound9;
					Boundaries[9].AWindow=AWindow9;
					Boundaries[9].AOthers=AOthers9;
					Boundaries[9].rhoBound=rhoBound9;
					Boundaries[9].cpBound=cpBound9;
					Boundaries[9].dBound=dBound9;
					Boundaries[9].gWindow=gWindow9;
					Boundaries[9].uBound=uBound9;
					Boundaries[9].uWindow=uWindow9;
					Boundaries[9].uOthers=uOthers9;
					Boundaries[9].epsDirt=epsDirt9;
					Boundaries[9].epsShading=epsShading9;
					Boundaries[9].epsFrame=epsFrame9;
					Boundaries[9].NormalVector=normalVector(alphaInclination9,alphaOrientation9);
					Boundaries[9].alphaInc=alphaInclination9;
					Boundaries[9].alphaOr=alphaOrientation9;					
					Boundaries[9].alphaBound=alphaBound9;
					Boundaries[9].contactBound=contactBound9;
					if not contactBound9>0 then				
						if (groundContact9) then
							Boundaries[9].alphaBoundOut=0;
							Boundaries[9].depthBound=depthBound9;
						else
							assert(alphaBoundOut9>1e-10,"Boundary 9 - alphaBoundOut=0");
							Boundaries[9].alphaBoundOut=alphaBoundOut9;
							Boundaries[9].depthBound=0;
						end if;
					else
						assert(alphaBoundOut9>1e-10,"Boundary 9 - alphaBoundOut=0");
						Boundaries[9].alphaBoundOut=alphaBoundOut9;
						Boundaries[9].depthBound=0;
					end if;	
					Boundaries[9].alphaBoundIn=alphaBoundIn9;
					if not contactBound9>0 then
						if (groundContact9) then
							Boundaries[9].lambdaBound=(dBound9)/((1/min(uBound9,alphaBoundIn9-1e-3))-(1/alphaBoundIn9));
						else
							Boundaries[9].lambdaBound=(dBound9)/((1/min(uBound9,((alphaBoundIn9*alphaBoundOut9)/(alphaBoundIn9+alphaBoundOut9)-1e-3)))-(1/alphaBoundIn9)-(1/alphaBoundOut9));
						end if;
					else
						Boundaries[9].lambdaBound=(dBound9)/((1/min(uBound9,((alphaBoundIn9*alphaBoundOut9)/(alphaBoundIn9+alphaBoundOut9)-1e-3)))-(1/alphaBoundIn9)-(1/alphaBoundOut9));
					end if;	
				end if;
			end for;
		
			for i in 1:Bound loop
				if (Boundaries[i].groundContact) then
					Boundaries[i].TGround=ground(Boundaries[i].depthBound,AmbientConditions.DayOfYear,AmbientConditions.LeapYear,AmbientConditions.cGround,AmbientConditions.lambdaGround,AmbientConditions.rhoGround,AmbientConditions.GeoGradient,AmbientConditions.TAverageAmbientAnnual,AmbientConditions.TAmbientMax,AmbientConditions.MaxMonth);
				else
					Boundaries[i].TGround=0;
				end if;
				TGround[i]=Boundaries[i].TGround;
			end for;	
			
			for i in 1:Bound loop
				if (not Boundaries[i].contactBound>0) then	
					if Boundaries[i].groundContact then
						TAmbientBound[i]=Boundaries[i].TGround;
					else
						TAmbientBound[i]=AmbientConditions.TAmbient;
					end if;
				else
					if(contactBound1>0) or (contactBound2>0 and Bound>1) or (contactBound3>0 and Bound>2) or (contactBound4>0 and Bound>3) or (contactBound5>0 and Bound>4) or (contactBound6>0 and Bound>5) or (contactBound7>0 and Bound>6) or (contactBound8>0 and Bound>7) or (contactBound9>0 and Bound>8) then
						TAmbientBound[i]=ZoneTemperatures[Boundaries[i].contactBound].ZoneTemperature;
					else
						TAmbientBound[i]=0;
					end if;
				end if;
			end for;			
		
			CZoneAir=AmbientConditions.cpAir*AmbientConditions.rhoAir*AZone*hZone;
			if (Mass>0) then
				CZoneMass=ThreeVectorMult(Masses.cp,Masses.rho,Masses.V,Mass);
			else
				CZoneMass=0;
			end if;
			if not LoadCalculation and Heat then
				TFlowHeat=FromFlow.TMedium;
				qvHeat=FromFlow.qvMedium;
			else
				TFlowHeat=0;
				qvHeat=0;
			end if;
			
			if (DINcalc) then
				if useDayTime then	
					CoolLoadFactorPerson.u[1]=AmbientConditions.HourOfDay;
					CoolLoadFactorLigth.u[1]=AmbientConditions.HourOfDay;
					CoolLoadFactorMachine.u[1]=AmbientConditions.HourOfDay;
					AppliedLoadFactorLight.u[1]=AmbientConditions.HourOfDay;
					AppliedLoadFactorMachine.u[1]=AmbientConditions.HourOfDay;
					NumberPersonDIN.u[1]=AmbientConditions.HourOfDay;
					PelDIN.u[1]=AmbientConditions.HourOfDay;
				else
					CoolLoadFactorPerson.u[1]=AmbientConditions.HourOfYear;
					CoolLoadFactorLigth.u[1]=AmbientConditions.HourOfYear;
					CoolLoadFactorMachine.u[1]=AmbientConditions.HourOfYear;
					AppliedLoadFactorLight.u[1]=AmbientConditions.HourOfYear;
					AppliedLoadFactorMachine.u[1]=AmbientConditions.HourOfYear;
					NumberPersonDIN.u[1]=AmbientConditions.HourOfYear;
					PelDIN.u[1]=AmbientConditions.HourOfYear;
				end if;
			else	
				if useDayTime then	
					ElectricalPower.u[1]=AmbientConditions.HourOfDay;
					ReactivePower.u[1]=AmbientConditions.HourOfDay;
					NumberPerson.u[1]=AmbientConditions.HourOfDay;
					BaseLoad.u[1]=AmbientConditions.HourOfDay;
					NormLoad.u[1]=AmbientConditions.HourOfDay;
					MachineLoad.u[1]=AmbientConditions.HourOfDay;
					LightLoad.u[1]=AmbientConditions.HourOfDay;
					InnerLoad.u[1]=AmbientConditions.HourOfDay;
				else
					ElectricalPower.u[1]=AmbientConditions.HourOfYear;
					ReactivePower.u[1]=AmbientConditions.HourOfYear;
					NumberPerson.u[1]=AmbientConditions.HourOfYear;
					BaseLoad.u[1]=AmbientConditions.HourOfYear;
					NormLoad.u[1]=AmbientConditions.HourOfYear;
					MachineLoad.u[1]=AmbientConditions.HourOfYear;
					LightLoad.u[1]=AmbientConditions.HourOfYear;
					InnerLoad.u[1]=AmbientConditions.HourOfYear;
				end if;
			end if;
			for i in 1:Bound loop
				der(deltaTBound[i])=0;
				AngleBound[i]=angleMinMax(diffAngle(AmbientConditions.RadiationVector,Boundaries[i].NormalVector),pi/2,0);	
				if useWindowShading then	
					QTransWindowAbsorp[i]=-Boundaries[i].gWindow*(1-WindowShading[i])*Boundaries[i].AWindow*(1-Boundaries[i].epsDirt)*(1-Boundaries[i].epsShading)*(1-Boundaries[i].epsFrame)*((AmbientConditions.RadiationDirect+0.25*AmbientConditions.RadiationDiffuse)*cos(AngleBound[i])+0.75*AmbientConditions.RadiationDiffuse*0.5*(cos(Boundaries[i].alphaInc)+1));
				else
					QTransWindowAbsorp[i]=-Boundaries[i].gWindow*Boundaries[i].AWindow*(1-Boundaries[i].epsDirt)*(1-Boundaries[i].epsShading)*(1-Boundaries[i].epsFrame)*((AmbientConditions.RadiationDirect+0.25*AmbientConditions.RadiationDiffuse)*cos(AngleBound[i])+0.75*AmbientConditions.RadiationDiffuse*0.5*(cos(Boundaries[i].alphaInc)+1));
				end if;
				QTransWindow[i]=(Boundaries[i].uWindow+uHeatBridge)*Boundaries[i].AWindow*(TZoneAct-TAmbientBound[i]);
				QTransOthers[i]=(Boundaries[i].uOthers+uHeatBridge)*Boundaries[i].AOthers*(TZoneAct-TAmbientBound[i]);
				if (Boundaries[i].groundContact) then
					QHeatBridgeAbsorp[i]=0;
					QBoundAbsorp[i]=0;
				else	
					QHeatBridgeAbsorp[i]=-uHeatBridge*(1-Boundaries[i].epsShading)*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(Boundaries[i].alphaBound/Boundaries[i].alphaBoundOut)*((AmbientConditions.RadiationDirect+0.25*AmbientConditions.RadiationDiffuse)*cos(AngleBound[i])+0.75*AmbientConditions.RadiationDiffuse*0.5*(cos(Boundaries[i].alphaInc)+1));
					QBoundAbsorp[i]=-(Boundaries[i].uBound)*(1-Boundaries[i].epsShading)*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(Boundaries[i].alphaBound/Boundaries[i].alphaBoundOut)*((AmbientConditions.RadiationDirect+0.25*AmbientConditions.RadiationDiffuse)*cos(AngleBound[i])+0.75*AmbientConditions.RadiationDiffuse*0.5*(cos(Boundaries[i].alphaInc)+1));
				end if;
				QHeatBridge[i]=uHeatBridge*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(TZoneAct-TAmbientBound[i]);
				QBoundIn[i]=-Boundaries[i].alphaBoundIn*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(Boundaries[i].TBoundIn-TZoneAct);
			
				if (Boundaries[i].dBound>1e-3) then
					QBoundChange[i]=-(Boundaries[i].lambdaBound/Boundaries[i].dBound)*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(Boundaries[i].TBoundOut-Boundaries[i].TBoundIn);
				else
					QBoundChange[i]=0;
				end if;			
				if (Boundaries[i].groundContact) then
					QBoundOut[i]=QBoundChange[i];
				else
					QBoundOut[i]=Boundaries[i].alphaBoundOut*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(Boundaries[i].TBoundOut-TAmbientBound[i])+QBoundAbsorp[i];
				end if;
				QBound[i]=(Boundaries[i].uBound)*(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*(TZoneAct-TAmbientBound[i])+QBoundAbsorp[i];					
						
			end for;
			QLAirLeak=AmbientConditions.cpAir*AmbientConditions.rhoAir*LAirLeak*AZone*hZone*(TZoneAct-AmbientConditions.TAmbient);
			if (DINcalc) then
				if not useVentilationSystem then
					QAirComfort=AmbientConditions.cpAir*AmbientConditions.rhoAir*LComfortVentilation*NumberPersonDIN.y[1]*(TZoneAct-AmbientConditions.TAmbient);
				else
					QAirComfort=AmbientConditions.cpAir*AmbientConditions.rhoAir*LComfortVentilation*NumberPersonDIN.y[1]*(TZoneAct-AmbientConditions.TAmbient)*(1-VentilationHeatExchangeRate);
				end if;
				QPerson=-(QBody+QPersonColdWater+QPersonElectricity)*NumberPersonDIN.y[1]*CoolLoadFactorPerson.y[1];
				QLight=-PLightInstall*CoolLoadFactorLigth.y[1]*AppliedLoadFactorLight.y[1];
				QMachine=-PMachineInstall*etaMachine*CoolLoadFactorMachine.y[1]*AppliedLoadFactorMachine.y[1];
				QBase=0;
				QInner=0;
				QNorm=0;
				QelHeat=-PelDIN.y[1];
				Pel=-(-QPersonElectricity*NumberPersonDIN.y[1]*CoolLoadFactorPerson.y[1]+QLight+QMachine+QBase+QNorm+QelHeat);
				Qel=0;
				if (QAirComfort>1e-10 and useVentilationSystem) then
					PVent=LComfortVentilation*VentPower*NumberPersonDIN.y[1];
					QVent=PVent*tan(acos(cosPhiVent));
				else
					PVent=0;
					QVent=0;
				end if;				
			else
				if not useVentilationSystem then
					QAirComfort=AmbientConditions.cpAir*AmbientConditions.rhoAir*LComfortVentilation*NumberPerson.y[1]*(TZoneAct-AmbientConditions.TAmbient);
				else
					QAirComfort=AmbientConditions.cpAir*AmbientConditions.rhoAir*LComfortVentilation*NumberPerson.y[1]*(TZoneAct-AmbientConditions.TAmbient)*(1-VentilationHeatExchangeRate);
				end if;
				QPerson=-(QBody+QPersonColdWater+QPersonElectricity)*NumberPerson.y[1];
				QLight=-LightLoad.y[1];
				QMachine=-MachineLoad.y[1];
				QBase=-BaseLoad.y[1];
				QInner=-InnerLoad.y[1];
				QNorm=-NormLoad.y[1];
				QelHeat=-ElectricalPower.y[1];
				Pel=-(-QPersonElectricity*NumberPerson.y[1]+QLight+QMachine+QBase+QNorm+QelHeat);
				Qel=ReactivePower.y[1];
				if (QAirComfort>1e-10 and useVentilationSystem) then
					PVent=LComfortVentilation*VentPower*NumberPerson.y[1];
					QVent=PVent*tan(acos(cosPhiVent));
				else
					PVent=0;
					QVent=0;
				end if;
			end if;
			QHeatCoolLoad=sumVector1(QBoundIn,Boundaries.dBound,1,Bound)+sumVector2(QBound,Boundaries.dBound,1,Bound)+sumVector(QHeatBridge,1,Bound)+sumVector(QHeatBridgeAbsorp,1,Bound)+sumVector(QTransWindow,1,Bound)+sumVector(QTransOthers,1,Bound)+sumVector(QTransWindowAbsorp,1,Bound)+QLAirLeak+QAirComfort+QPerson+QLight+QMachine+QInner+QNorm+QBase+QelHeat;	
			QTotal=sumVector(QHeatBridge,1,Bound)+sumVector(QHeatBridgeAbsorp,1,Bound)+sumVector(QTransWindow,1,Bound)+sumVector(QTransOthers,1,Bound)+sumVector(QTransWindowAbsorp,1,Bound)+QLAirLeak+QAirComfort+QPerson+QLight+QMachine+QInner+QNorm+QBase+QelHeat;	
			
			if LoadCalculation then
				HeatCoolLoad=QHeatCoolLoad;
			end if;
						
			if not LoadCalculation and Heat then
				cpMedHeat*rhoMedHeat*VHeatMedium*der(TReturnHeat-TZoneAct)=-(abs(((TOverLog(min(max((TReturnHeat-TZoneAct),0),65),min(max((TFlowHeat-TZoneAct),5),75)))/(TOverLogNorm(min(max((TReturnHeatNorm-TZoneNorm),5),55),min(max((TFlowHeatNorm-TZoneNorm),5),75)))))^n)*QHeatNorm*AZone+cpMedHeat*rhoMedHeat*qvHeat*(TFlowHeat-TReturnHeat);
			else
				TReturnHeat=0;
			end if;
			
			if LoadCalculation then
				der(TZoneAct)=der(TZoneRef);
			else
				(CZoneAir+CZoneMass)*der(TZoneAct)=QHeat-QTotal-sumVector1(QBoundIn,Boundaries.dBound,1,Bound)-sumVector2(QBound,Boundaries.dBound,1,Bound);
			end if;
			
			for i in 1:Bound loop
				if (Boundaries[i].dBound>1e-3) then
					(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*Boundaries[i].dBound/2*Boundaries[i].rhoBound*Boundaries[i].cpBound*der(Boundaries[i].TBoundIn)=QBoundIn[i]-QBoundChange[i];
					if (Boundaries[i].groundContact) then
						der(Boundaries[i].TBoundOut)=der(TAmbientBound[i]);
					else
						(Boundaries[i].ABound-Boundaries[i].AWindow-Boundaries[i].AOthers)*Boundaries[i].dBound/2*Boundaries[i].rhoBound*Boundaries[i].cpBound*der(Boundaries[i].TBoundOut)=-QBoundOut[i]+QBoundChange[i];
					end if;
				else
					der(Boundaries[i].TBoundIn)=der(TZoneAct);
					der(Boundaries[i].TBoundOut)=der(TAmbientBound[i]);
				end if;
			end for;
																								
			if not LoadCalculation and Heat then
				ToReturn.TMedium=TReturnHeat;
				ToReturn.qvMedium=qvHeat;
			end if;
		
				
				GridConnection.I=calc_current((Pel+PVent),GridConnection.V);
			
			
			if not LoadCalculation and Heat then
				QHeat=cpMedHeat*rhoMedHeat*qvHeat*(TFlowHeat-TReturnHeat);
			else	
				QHeat=0;
			end if;
			
			TZone=TZoneAct;
			der(EHeat)=QHeat;
			der(Eel)=Pel;
			
			for i in 1:Bound loop
				TBoundIn[i]=Boundaries[i].TBoundIn;
				TBoundOut[i]=Boundaries[i].TBoundOut;				
			end for;
		
		if not LoadCalculation and Heat then	
		connect(ToReturn.Pipe,HeatReturn) annotation(Line(
			points={{365,-505},{360,-505},{325,-505},{320,-505}},
			color={190,30,45}));
		end if;
		if not LoadCalculation and Heat then
		connect(FromFlow.Pipe,HeatFlow) annotation(Line(
			points={{365,-460},{360,-460},{325,-460},{320,-460}},
			color={190,30,45}));
		end if;
		connect(GridConnection.FlowCurrent,Grid) annotation(
			Line(
				points={{480,-644},{520,-635},{480,-700}},
				color={247,148,29}),
			AutoRoute=false);
	annotation(
		Icon(
			coordinateSystem(extent={{-350,-200},{350,200}}),
			graphics={
				Bitmap(
					imageSource="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
SUVORK5CYII=",
					extent={{-360,267},{373,-279}}),
				Text(
					textString="%ZoneIndex",
					extent={{-367,167},{-197,23}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\ghosh\\AppData\\Local\\Temp\\6\\itiA32B.tmp\\hlp7D64.tmp\\HeatedZoneDC.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<=21DOCTYPE html PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22 =22=22><=
HTML xmlns:o=3D=22urn:schemas-microsoft-com:office:office=22><HEAD><TITLE>Bu=
ilding 
zone simulating inner heat losses and yields as well as heating system behav=
ior 
V1.0</TITLE> 
<META http-equiv=3D=22Content-Type=22 content=3D=22text/html; charset=3Diso-=
8859-1=22> 
<STYLE type=3D=22text/css=22>
p, li =7Bfont-family: Verdana, Arial, Helvetic=
a, sans-serif; font-size:12px; color: =23000000;=7D
.Ueberschrift1 =7Bfont-f=
amily: Verdana, Arial, Helvetica, sans-serif; font-size:14px; font-weight:bo=
ld; color:=23000000; margin-top:0; margin-bottom:6px;=7D
.Ueberschrift2 =7Bf=
ont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px; font-weig=
ht:bold; color:=23000000; margin-top:6px; margin-bottom:6px;=7D
.Ueberschrif=
t3 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px; fo=
nt-weight:bold; font-style:italic; color:=23000000; margin-top:6px; margin-b=
ottom:6px;=7D
.SymbolTab =7Bfont-family: Verdana, Arial, Helvetica, sans-ser=
if; font-size:12px; font-weight:bold; color:=23000000;=7D
</STYLE>
 <LINK href=3D=22../format_help.css=22 rel=3D=22stylesheet=22> 
<META name=3D=22GENERATOR=22 content=3D=22MSHTML 11.00.9600.18525=22></HEAD>=
 
<BODY bgcolor=3D=22=23ffffff=22 link=3D=22=230000ff=22 vlink=3D=22=23800080=
=22>
<P class=3D=22Ueberschrift1=22 style=3D=22margin-top: 0px; margin-bottom: 0p=
x;=22>Building 
zone  simulating inner heat losses and yields as well as heating system beha=
vior 
 V1.0</P>
<HR size=3D=221=22 style=3D=22margin-top: 0px; margin-bottom: 0px;=22 noshad=
e=3D=22=22>

<TABLE width=3D=22100%=22 bordercolor=3D=22=23ffffff=22 bordercolorlight=3D=
=22=23ffffff=22 
bordercolordark=3D=22=23ffffff=22 bgcolor=3D=22=23cccccc=22 border=3D=221=22=
 cellspacing=3D=220=22 
cellpadding=3D=222=22>
  <TBODY>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Symbol:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23ffffff=22 colspan=3D=223=22><IMG =
width=3D=22214=22 height=3D=22124=22 
      src=3D=22HeatedZoneDC=5Csymbol.png=22></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Ident:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22>GreenBuilding.Building.HeatedZone</P></TD><=
/TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Version:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22>1.0</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>File:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22></P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Connectors:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Zone temperature</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TZone</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Flow pipe</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>HeatFlow</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Return pipe</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>HeatReturn</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>3-phase connection to Grid</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Grid3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Ambient Conditions Connection</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AmbientConditions</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Parameters:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Zone Index</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ZoneIndex</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Number of Zones</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>NumberZones</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Number of Boundaries</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Bound</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Number of inner Masses</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Mass</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Initial zone temperature</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TZoneInit</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Initial return temperature of heating syste=
m</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TReturnHeatInit</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>If enabled, only cooling and heating load =

      calculation,       else dynamic zone temperature simulation</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LoadCalculation</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>If enabled, database =3D HourOfDay, else da=
tabase =3D     
        HourOfYear</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>useDayTime</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>External shading of windows, separately for=
 each      
       boundary is enabled</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>useWindowShading</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Net floor space of the zone</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AZone</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Height of zone</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>hZone</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Installed electrical power of light</P></TD=
>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PLightInstall</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Installed electrical power of machines</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PMachineInstall</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Efficiency factor of machines</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>etaMachine</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>DIN calculations enabled/disabled</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>DINcalc</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for DIN cool load factors</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>CoolFactorTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for DIN load factors for light</=
P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LoadLightTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for DIN load factors for machine=
s</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LoadMachineTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>File name for DIN cool and load factors</P>=
</TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>DINFile</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>File name for number of persons while DIN  =
     
      calculations</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>NumberPersonDINFile</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for number of persons while DIN =
      
      calculations</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>NumberPersonDINTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>File name for electrical power while DIN   =
    
      calculations</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PelDINFile</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for electrical power while DIN  =
     
      calculations</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PelDINTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>File name for inner loads</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>InputDataFile</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to body heat=
 of that   
          number of person</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>NumberPersonTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to basic loa=
ds</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>BaseLoadTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to normal lo=
ads</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>NormLoadTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to machines<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>MachineLoadTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to light</P>=
</TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LightLoadTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for inner loads due to other loa=
ds</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>InnerLoadTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for further electrical power    =
   
      characteristics</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PelTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name for further electrical power    =
   
      characteristics</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QelTable</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heating is enabled/disabled</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of heat media</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMedHeat</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of heat media</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMedHeat</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heating system exponent (1.1: floor heating=
, 1.2-1.3: 
            panel radiator, 1.25: ribbed radiator, 1.3: radiator, 1.25-1.45:=
     
        convector)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>n</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Normal flow temperature of heating system</=
P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TFlowHeatNorm</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Normal return temperature of heating system=
</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TReturnHeatNorm</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Normal zone temperature for heating system<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TZoneNorm</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Normal heating power per m2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QHeatNorm</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of heating system</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VHeatMedium</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Body heat dissipation per person</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QBody</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Individual heat losses by cold water usage =
per       
      person</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QPersonColdWater</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat dissipation by usage of electrical dev=
ices per   
          person</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QPersonElectricity</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Air leak of zone</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LAirLeak</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Air volume flow of ventilation due to comfo=
rt</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>LComfortVentilation</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>If enabled, ventilation losses and gains ar=
e modified 
            by VentilationHeatExchangeRate</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>useVentilationSystem</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat exchange correction factor (heating an=
d cooling) 
            for ventilation losses by using ventilation systems</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VentilationHeatExchangeRate</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Electrical power of ventilation system 
     =5BW/(m3/s)=5D</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VentPower</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Power factor of ventilation system</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cosPhiVent</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Equlivalent additional heat transmission va=
lue for 
      heat       bridges</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uHeatBridge</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of inner Mass 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VMass1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of inner Mass 1</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMass1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of inner Mass 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMass1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of inner Mass 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VMass2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of inner Mass 2</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMass2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of inner Mass 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMass2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of inner Mass 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VMass3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of inner Mass 3</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMass3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of inner Mass 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMass3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of inner Mass 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VMass4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of inner Mass 4</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMass4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of inner Mass 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMass4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 1 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 1</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 1</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 1</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 1 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 1, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 1 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 1 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 1 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 1<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 1</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     1</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 2 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 2</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 2</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 2</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 2 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 2, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 2 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>shading correction value for Boundary 2 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 2 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 2<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 2</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     2</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn2</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 3 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 3</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 3</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 3</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 3 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 3, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 3 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 3 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 3 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 3<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 3</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     3</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn3</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 4 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 4</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 4</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 4</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 4 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 4, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 4 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 4 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 4 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 4<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 4</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     4</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn4</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 5 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 5</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 5</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 5</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 5 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 5, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 5 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 5 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 5 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 5<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 5</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     5</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn5</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 6 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 6</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 6</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 6</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 6 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 6, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 6 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 6 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 6 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 6<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 6</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     6</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn6</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 7 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 7</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 7</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 7</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 7 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 7, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 7 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 7 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 7 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 7<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 7</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     7</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn7</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 8 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 8</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 8</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 8</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 8 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 8, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 8 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>shading correction value for Boundary 8 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 8 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 8<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 8</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     8</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn8</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 9 is connected to: '0'-Ambience, '=
1,2,3      
       ...-Zone 1,2,3 ...</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>contactBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Surface area of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ABound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Window surface area of boundary 9</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AWindow9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Other surface area of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>AOthers9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Thickness of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>dBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of boundary 9</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of boundary 9</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of window in bounda=
ry 
9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uWindow9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat transmission value of other surfaces i=
n boundary 
            9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>uOthers9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Boundary 9 has contact to ground</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>groundContact9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Depth of boundary 9, if it is ground contac=
ted</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>depthBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Dirt correction value for window in boundar=
y 9 (0:    
         fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsDirt9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Shading correction value for boundary 9 (0:=
 fully     
        irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsShading9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Frame correction value for window in bounda=
ry 9 (0:   
          fully irradiated, 1: fully shaded)</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>epsFrame9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inclination angle of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaInclination9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Orientation angle of boundary 9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaOrientation9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Total translucency of window in boundary 9<=
/P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>gWindow9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Absorption coefficient of boundary 9</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBound9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Outer heat transmission coefficient of boun=
dary 
     9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundOut9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Inner heat transmission coefficient of boun=
dary 
     9</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>alphaBoundIn9</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Results:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Zone temperature</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TZone</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Control output for resulting heating and co=
oling load 
            when Heating-Cooling-Load-Calculation is used</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>HeatCoolLoad</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat power</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QHeat</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Electrical effective power of the zone</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Pel</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Energy, used for heating the zone during si=
mulation   
          time period</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>EHeat</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Electrical energy demand of the zone during=
 
      simulation       time period</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Eel</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3D=22Ueberschrift2=22>Description:</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>The Heated Zone model =
simulates 
 various influences on the internal temperature in a building. Additionally,=
 it 
 conduces to include the behavior of persons inside a building into a buildi=
ng 
 energy system model regarding electricity and heat demand. One zone model c=
an 
be  coupled with other zone models via the zone temperature interface. That =
way, 
it  is possible to model a complex building with different rooms or zones an=
d 
 different heat and electricity demand. In opposite to 'BuildingZone'-model =
the 
 'HeatedZone' offers to simulate a building internal heating system (e.g. fl=
oor 
 heating). Therefore a heating system could be directly connected to model v=
ia 
 flow and return pipe (if 'LoadCalculation' and 'Heat' are 'true').</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>The zone temperature d=
epends on 
 various influences:</P>
<UL>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Heat transmission =
through   
  walls, windows and other boundaries (e.g. doors) (<SPAN lang=3D=22DE=22 st=
yle=3D=22mso-ansi-language: DE;=22><FONT 
  size=3D=222=22>q<SUB>trans</SUB></FONT></SPAN>)</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Heat bridge losses=
 (<SPAN 
  lang=3D=22DE=22 style=3D=22mso-ansi-language: DE;=22><FONT 
  size=3D=222=22>q<SUB>HB</SUB></FONT></SPAN>)</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Solar yields (<FON=
T 
  size=3D=222=22><SPAN lang=3D=22DE=22 
  style=3D=22mso-ansi-language: DE;=22>q<SUB>sol</SUB></SPAN>)</FONT></DIV>=

  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Ventilation losses=
 (<SPAN 
  lang=3D=22DE=22 style=3D=22mso-ansi-language: DE;=22><FONT 
  size=3D=222=22>q<SUB>vent</SUB></FONT></SPAN>)</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Internal yields an=
d losses   
  via persons as well as electricity and water usage (<SPAN lang=3D=22DE=22 =
style=3D=22mso-ansi-language: DE;=22><SPAN 
  lang=3D=22DE=22 style=3D=22mso-ansi-language: DE;=22><FONT size=3D=222=22>=
q<SUB>el</SUB>,   
  q<SUB>pers</SUB>)</FONT></SPAN></SPAN></DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22><SPAN lang=3D=22DE=
=22 style=3D=22mso-ansi-language: DE;=22><SPAN 
  lang=3D=22DE=22 style=3D=22mso-ansi-language: DE;=22><FONT 
  size=3D=223=22><o:p></o:p></FONT></SPAN></SPAN>Internal heat storage (air,=
 walls,   
  inner masses) (Q)</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Heating via heatin=
g system   
  (<FONT face=3D=22Verdana=22><SPAN lang=3D=22DE=22 style=3D'line-height: 11=
5%; font-family: =22Calibri=22,=22sans-serif=22; font-size: 11pt; mso-ansi-l=
anguage: DE; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Cal=
ibri; mso-fareast-theme-font: minor-latin; mso-hansi-theme-font: minor-latin=
; mso-bidi-font-family: =22Times New Roman=22; mso-bidi-theme-font: minor-bi=
di; mso-fareast-language: EN-US; mso-bidi-language: AR-SA;'>q<SUB>HT</SUB></=
SPAN>)</FONT></DIV></LI></UL>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22><IMG width=3D=22763=22=
 height=3D=22439=22 
align=3D=22baseline=22 style=3D=22width: 772px; height: 482px;=22 alt=3D=22=
=22 src=3D=22HeatedZoneDC=5Cequa_zone.png=22 
border=3D=220=22 hspace=3D=220=22></P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>&nbsp;</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>To simulate the temper=
ature 
 characteristic in a building zone various system parameters have to be defi=
ned 
 before the simulation process. Firstly, the model parameter dialogue and th=
e 
 model itself have to be configured:</P>
<UL>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Zone number visual=
izes the   
  parameterized zone model in a complex simulation model. If the zone should=
 be  
   coupled with other neighboring building zones, the number of zones in the=
   
  desired simulation model has to be defined. </DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Number of boundari=
es (max: 
  9,   min: 1) defines how many boundaries (wall etc.) should be modeled. Nu=
mber 
  of   inner masses (max: 4, min: 0) defines the number of internal addition=
al 
  heat   storages (e.g. inner walls and ceilings).</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>To initialize the =
simulation 
    system the initial indoor temperature and return temperature of heating =

  system   at simulation begin have to be defined.</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>LoadCalculation de=
cides, if  
   the zone model should only be used to calculate heating and cooling load =
of   
  the zone depending on outer influences (zone temperature follows reference=
   
  zone temperature level - TZoneRef has to be connected) or if the zone   
  temperature should be simulated depending heat yields and losses as well a=
s   
  heating (flow and return pipe of heating system have to be connected).</DI=
V>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>To define the desi=
red   
  simulation process, useDayTime has to be set to 'true', if the input data =
sets 
    for persons' behavior and electricity demand are defined only for one da=
y   
  (24h). Otherwise (input data sets are defined for specific time in the yea=
r -  
   0&nbsp;to 8760h) this parameter should be set to 'false'.</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>useWindowShading o=
ffers   
  shading of windows in each boundary with external signals (0: fully   
  irradiated, 1: fully shaded). If this value is set to 'true' the external =
  
  WindowShading signal vector (dimension is number of boundaries) has to be =
  
  defined with external data (real values - max: 1 (fully shaded), min: 0 (f=
ully 
    irradiated)) for each vector component. Otherwise numerical problems cou=
ld   
  occur. Mostly, this feature is used in combination with building energy   =

  management systems.</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>DINcalc in paramet=
er 
  dialogue   'Heat and Cool Factors I' defines, if internal heat loads, 
  electrical power   demand and the presence of persons in the zone should b=
e 
  modeled using input   data of DIN standards (DIN 2078) or external 
  free-parameterizable input data   sets.</DIV></LI></UL>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>If the heated zone sho=
uld not be 
 heated by a heating system, parameter 'Heat' should be set to 'false'. 
Otherwise  the heating system has to be parameterized at the parameter dialo=
gue. 
The volume  information of heating medium is needed to avoid numerical probl=
ems. 
Depending  on the&nbsp;selected heating system, it should be set to 100 to 1=
50l 
per 100m2  net floor space of the zone (equal to floor heating system). 
Installed normal  heating power is defined as heat power per m2 net floor sp=
ace 
area. Mostly this  value can be defined from 20W to 200W. Type of heating sy=
stem 
(e.g. floor  heating system) is defined via Heating System Exponent (n):</P>=

<UL>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>n=3D1.1: floor hea=
ting</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>n=3D1.2-1.3: panel=
   
  radiator</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>n=3D1.25: ribbed =

radiator</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>n=3D1.3: radiator<=
/DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>n=3D1.25-1.45:   =

  convector</DIV></LI></UL>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>This exponent defines =
the share 
 of heat convection and radiation depending on heating system design.</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Furthermore internal h=
eat yields 
 per person have to be parameterized (heat of body, heat losses because of c=
old 
 water usage, heat yields because usage of electric devices). The ventilatio=
n 
 losses are defined via air leakage through boundaries. To assure an adequat=
e 
 CO2-level in the zone and an adequate humidity further ventilation is neede=
d. 
 So, these losses are defined by an additional air volume flow between zone =
and 
 ambience (LComfortVentilation, normally 25m3/h per person). This air volume=
 
flow  can be made by window opening or an active ventilation system. Such an=
 
active  ventilation system causes an additional electricity demand depending=
 on 
the  resulting volume flow. Also a heat recovery rate can be defined.</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Inner masses are addit=
ional heat 
 storages within the building zone. To simplify the simulation process it is=
 
 assumed that these masses always stay at indoor room temperature level.</P>=

<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Each boundary has to b=
e 
 parameterized separately. Therefore surface areas of walls, windows etc. of=
 
each  boundary as well as heat transmission factors (U-Value) and material =

constants  (heat capacity and density) have to be defined. Enabling a free =

configuration of  the building zone the alignment of each boundary has to be=
 
determined via  inclination and orientation angle:</P>
<UL>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Inclination angle:=
 90=B0   
  vertical wall, 0=B0 flat ceiling or floor.</DIV>
  <LI>
  <DIV style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Orientation angle:=
 0=B0 -    
  boundary normal points towards north, 90=B0 - east, 180=B0 - south, 270=B0=
   
  west.</DIV></LI></UL>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Additional correction =
factors 
can  be used to describe solar radiation absorption more detailed. Frame and=
 
dirt  correction factors are only used to reduce solar radiation absorption =
of 
 windows. Shading correction factor is additionally used to adapt heat 
absorption  of walls. So if one boundary is a building internal wall or ceil=
ing 
which is not  irradiated by the sun, shading correction factor has to be set=
 to 
1. Generally,  these correction factors reduce solar yields (maximum shading=
: 
1).</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>If a building should c=
onsist of 
 several building zones and heat should be interchanged between these zones =

 during a simulation process, it is necessary to connect neighboring zones =

within  the simulation model. So if the maximum number of zones is set great=
er 
than 1  the parameter 'contactBound' can be set to the number of the neighbo=
ring 
zone of  each boundary (1, 2, 3 ....). If this parameter stays at value 0, t=
he 
boundary  is connected up to ambience.</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>If ambience of a bound=
ary should 
 be the ground surface, parameter 'groundContact' has to be set to 'true'. T=
hen 
 the depth of the connected ground surface can be defined. For vertical wall=
s 
 with ground contact, use the average depth of the wall. If a boundary is 
 connected to ground, main heat transmission happens via heat conductance. S=
o, 
 the outer heat transmission factor disappears. Normally for outer walls, th=
is 
 factor is set to a value of about 20W/m2. In opposite to that inner heat 
 transmission factors normally are set to a value of about 7.5W/m2. The 
 additional absorption coefficient describes the influence of the outer wall=
 
 color regarding solar heat absorbance (white 0.2, dark grey 0.8). </P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Basically, a reduced s=
et of 
 result characteristics can be visualized via corresponding&nbsp;results 
 dialogue. However, additional output characteristics, like solar gains, 
 ventilation losses, etc., can enabled via TypeDesigner by setting correspon=
ding 
 and predefined output variables from protected to public.</P></BODY></HTML>=



----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HeatedZoneDC\\symbol.png

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

----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HeatedZoneDC\\equa_zone.png

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

----$iti$--"),
		experiment(
			StopTime=1,
			StartTime=0,
			Interval=0.002,
			MaxInterval="10",
			AbsTolerance="1e-06"));
end HeatedZoneDC;
