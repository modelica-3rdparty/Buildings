within OCTExamples.ScalableBenchmarks.BuildingVAV.BaseClasses;
expandable connector ControlBus
  "Control bus that is adapted to the signals connected to it"
  extends Modelica.Icons.SignalBus;

  Modelica.SIunits.Temperature TRooMin "Minimum temperature of multiple zones";
  Modelica.SIunits.Temperature TRooAve "Average temperature of multiple zones";
  Modelica.SIunits.Temperature TRooSetHea "Room heating setpoint temperature";
  Modelica.SIunits.Temperature TRooSetCoo "Room cooling setpoint temperature";
  Modelica.SIunits.Temperature TOut "Outdoor air temperature";
  Modelica.SIunits.Time dTNexOcc "Time to next occupancy period";
  Boolean occupied "Occupancy status";
  Integer controlMode "System operation modes";

  annotation (
    Documentation(info="<html>
<p>
This connector defines the <code>expandable connector</code> ControlBus that
is used to connect control signals.
Note, this connector is empty. When using it, the actual content is
constructed by the signals connected to this bus.
</p>
</html>"));
end ControlBus;