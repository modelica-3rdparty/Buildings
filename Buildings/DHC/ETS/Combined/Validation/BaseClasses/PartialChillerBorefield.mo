within Buildings.DHC.ETS.Combined.Validation.BaseClasses;
partial model PartialChillerBorefield
  "Partial validation of the ETS model with heat recovery chiller and optional borefield"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=0.9*datChi.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=0.9*datChi.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=
       -1e6 "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)=
       abs(QCoo_flow_nominal)*(1 + 1/datChi.COP_nominal)
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=QCoo_flow_nominal,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=abs(QCoo_flow_nominal)/5/4186,
    mCon_flow_nominal=QHea_flow_nominal/5/4186,
    TEvaLvg_nominal=277.15,
    capFunT={1.72,0.02,0,-0.02,0,0},
    EIRFunT={0.28,-0.02,0,0.02,0,0},
    EIRFunPLR={0.1,0.9,0},
    TEvaLvgMin=277.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=298.15,
    TConEntMax=328.15) "Chiller performance data"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=45+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=7+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare package
      Medium = Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare package
      Medium = Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,40})));
  Buildings.DHC.ETS.Combined.ChillerBorefield ets(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    QChiWat_flow_nominal=QCoo_flow_nominal,
    QHeaWat_flow_nominal=QHea_flow_nominal,
    dp1Hex_nominal=40E3,
    dp2Hex_nominal=40E3,
    QHex_flow_nominal=-QCoo_flow_nominal,
    T_a1Hex_nominal=284.15,
    T_b1Hex_nominal=279.15,
    T_a2Hex_nominal=277.15,
    T_b2Hex_nominal=282.15,
    QWSE_flow_nominal=QCoo_flow_nominal,
    dpCon_nominal=40E3,
    dpEva_nominal=40E3,
    datChi=datChi,
    nPorts_bChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1)
    "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final
      package Medium = Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-28})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final
      package Medium = Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,0})));
  Buildings.Fluid.Sources.Boundary_pT disWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "District water boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-140})));
  DHC.ETS.BaseClasses.Pump_m_flow pumChiWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3) "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=
        mChiWat_flow_nominal) "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=
        mHeaWat_flow_nominal) "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{40,90},{20,110}})));
  DHC.ETS.BaseClasses.Pump_m_flow pumHeaWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3) "Heating water distribution pump"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=45 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts=2) "Volume for heating water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-111,0})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(final k=-ets.QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=7 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts=2) "Volume for chilled water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={149,0})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(final k=-ets.QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,50},{162,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold uHea(
    final t=0.01,
    final h=0.005)
    "Enable heating"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold uCoo(
    final t=0.01,
    final h=0.005)
    "Enable cooling"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Modelica.Blocks.Routing.RealPassThrough heaLoaNor
    "Connect with normalized heating load"
    annotation (Placement(transformation(extent={{-250,50},{-230,70}})));
  Modelica.Blocks.Routing.RealPassThrough loaCooNor
    "Connect with normalized cooling load"
    annotation (Placement(transformation(extent={{270,50},{250,70}})));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
      0,11;
      49,11;
      50,20;
      100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableName="tab1",
    table=[
      0,0,0;
      1,0,0;
      2,0,1;
      3,0,1;
      4,0,0.5;
      5,0,0.5;
      6,0,0.1;
      7,0,0.1;
      8,0,0;
      9,0,0;
      10,0,0;
      11,0,0;
      12,0,0;
      13,1,0;
      14,1,0;
      15,0.5,0;
      16,0.5,0;
      17,0.1,0;
      18,0.1,0;
      19,0,0;
      20,0,0;
      21,0,0;
      22,0,0;
      23,0,0;
      24,0,1;
      25,1,1;
      26,1,0.5;
      27,0.5,0.5;
      28,0.5,0.1;
      29,0.1,0.1;
      30,0.1,0;
      31,0,0;
      32,0,0;
      33,0,0;
      34,0,0;
      35,0,1;
      36,0.1,1;
      37,0.1,0.5;
      38,0.5,0.5;
      39,0.5,0.1;
      40,1,0.1;
      41,1,0;
      42,0,0;
      43,0,0;
      44,0,0;
      45,0,0;
      46,0,0.3;
      47,0.1,0.3;
      48,0.1,0.1;
      49,0.3,0.1;
      50,0.3,0.1;
      51,0.1,0.1;
      52,0.1,0;
      53,0,0;
      54,0,0;
      55,0,0;
      56,0,0;
      57,1,1;
      58,1,1;
      59,0.5,0.5;
      60,0.5,0.5;
      61,0.1,0.1;
      62,0.1,0.1;
      63,0,0;
      64,0,0;
      65,0,0;
      66,0,0;
      67,1,0;
      68,1,1;
      69,0.5,1;
      70,0.5,0.5;
      71,0.1,0.5;
      72,0.1,0.1;
      73,0,0.1;
      74,0,0.1;
      75,0,0;
      76,0,0;
      77,0,0;
      78,0,0;
      79,0.1,0;
      80,0.1,1;
      81,0.5,1;
      82,0.5,0.5;
      83,1,0.5;
      84,1,0.1;
      85,0,0.1;
      86,0,0.1;
      87,0,0;
      88,0,0;
      89,0,0;
      90,0,0;
      91,0.1,0;
      92,0.1,0.3;
      93,0.3,0.3;
      94,0.3,0.1;
      95,0.1,0.1;
      96,0.1,0.1;
      97,0,0.1;
      98,0,0;
      99,0,0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={0,0},
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisWatSup(redeclare final
      package Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-74})));
  Modelica.Blocks.Continuous.Integrator EChi(
    y(unit="J"))
    "Chiller electricity use"
    annotation (Placement(transformation(extent={{300,-70},{320,-50}})));
  Fluid.Sensors.TemperatureTwoPort senTDisWatRet(redeclare final package Medium =
        Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,-74})));
equation
  connect(TChiWatSupSet.y,ets.TChiWatSupSet)
    annotation (Line(points={{-118,100},{-32,100},{-32,-64},{-14,-64}},color={0,0,127}));
  connect(THeaWatSupSet.y,ets.THeaWatSupSet)
    annotation (Line(points={{-118,140},{-28,140},{-28,-58},{-14,-58}},color={0,0,127}));
  connect(pumChiWat.port_a,senTChiWatSup.port_b)
    annotation (Line(points={{110,40},{100,40}},color={0,127,255}));
  connect(gai2.y,pumChiWat.m_flow_in)
    annotation (Line(points={{112,100},{120,100},{120,52}},color={0,0,127}));
  connect(pumHeaWat.port_b,senTHeaWatSup.port_a)
    annotation (Line(points={{-10,40},{-50,40}},color={0,127,255}));
  connect(gai1.y,pumHeaWat.m_flow_in)
    annotation (Line(points={{18,100},{0,100},{0,52}},color={0,0,127}));
  connect(gai3.y,loaHea.Q_flow)
    annotation (Line(points={{-158,60},{-140,60}},color={0,0,127}));
  connect(loaHea.port,volHeaWat.heatPort)
    annotation (Line(points={{-120,60},{-112,60},{-112,10},{-111,10}},color={191,0,0}));
  connect(pumChiWat.port_b,volChiWat.ports[1])
    annotation (Line(points={{130,40},{139,40},{139,1}},color={0,127,255}));
  connect(volChiWat.ports[2],senTChiWatRet.port_a)
    annotation (Line(points={{139,-1},{139,0},{100,0}},color={0,127,255}));
  connect(senTHeaWatSup.port_b,volHeaWat.ports[1])
    annotation (Line(points={{-70,40},{-101,40},{-101,1}},color={0,127,255}));
  connect(gai4.y,loaCoo.Q_flow)
    annotation (Line(points={{198,60},{182,60}},color={0,0,127}));
  connect(loaCoo.port,volChiWat.heatPort)
    annotation (Line(points={{162,60},{149,60},{149,10}},color={191,0,0}));
  connect(volHeaWat.ports[2],senTHeaWatRet.port_a)
    annotation (Line(points={{-101,-1},{-101,-28},{-70,-28}},color={0,127,255}));
  connect(heaLoaNor.y,gai3.u)
    annotation (Line(points={{-229,60},{-182,60}},color={0,0,127}));
  connect(heaLoaNor.y,uHea.u)
    annotation (Line(points={{-229,60},{-220,60},{-220,-20},{-202,-20}},color={0,0,127}));
  connect(heaLoaNor.y,gai1.u)
    annotation (Line(points={{-229,60},{-220,60},{-220,120},{60,120},{60,100},{42,100}},color={0,0,127}));
  connect(loaCooNor.y,gai4.u)
    annotation (Line(points={{249,60},{222,60}},color={0,0,127}));
  connect(loaCooNor.y,gai2.u)
    annotation (Line(points={{249,60},{240,60},{240,120},{80,120},{80,100},{88,100}},color={0,0,127}));
  connect(loaCooNor.y,uCoo.u)
    annotation (Line(points={{249,60},{240,60},{240,-120},{-220,-120},{-220,-100},{-202,-100}},color={0,0,127}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-309,-140},{-140,-140},{-140,-136},{-122,-136}},color={0,0,127}));
  connect(uCoo.y,ets.uCoo)
    annotation (Line(points={{-178,-100},{-120,-100},{-120,-52},{-14,-52}},color={255,0,255}));
  connect(uHea.y,ets.uHea)
    annotation (Line(points={{-178,-20},{-120,-20},{-120,-46},{-14,-46}},color={255,0,255}));
  connect(disWat.ports[1],senTDisWatSup.port_a)
    annotation (Line(points={{-100,-141},{-100,-74},{-70,-74}},color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb)
   annotation (Line(points={{-50,-74},{-10,-74}},color={0,127,255}));
  connect(ets.ports_bChiWat[1],senTChiWatSup.port_a)
    annotation (Line(points={{50,-38},{70,-38},{70,40},{80,40}},color={0,127,255}));
  connect(ets.ports_bHeaWat[1],pumHeaWat.port_a)
    annotation (Line(points={{50,-28},{60,-28},{60,40},{10,40}},color={0,127,255}));
  connect(senTHeaWatRet.port_b,ets.ports_aHeaWat[1])
    annotation (Line(points={{-50,-28},{-10,-28}},color={0,127,255}));
  connect(senTChiWatRet.port_b,ets.ports_aChiWat[1])
    annotation (Line(points={{80,0},{-40,0},{-40,-38},{-10,-38}},color={0,127,255}));
  connect(ets.PCoo, EChi.u)
    annotation (Line(points={{54,-50},{60,-50},{60,-60},{298,-60}},color={0,0,127}));
  connect(ets.port_bSerAmb, senTDisWatRet.port_a)
    annotation (Line(points={{50,-74},{90,-74}}, color={0,127,255}));
  connect(senTDisWatRet.port_b, disWat.ports[2])
   annotation (Line(points={{110,-74},{160,-74},{160,-180},{-100,-180},{-100,-139}},color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-340,-220},{340,220}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 6, 2025, by Hongxiang Fu:<br/>
Revised load curves so that the heating and cooling loads can be staggered
instead of always appearing and disappearing at the same time.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4133\">#4133</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a partial model used as a base class to construct the
validation and example models.
</p>
<ul>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided
by the building automation system are here computed based on the condition
that the load is greater than 1% of the nominal load.
</li>
<li>
Simplified chiller performance data are used, which represent a linear
variation of the EIR and the capacity with the evaporator outlet temperature
and the condenser inlet temperature (no variation of the EIR at part
load is considered).
</li>
</ul>
</html>"));
end PartialChillerBorefield;
