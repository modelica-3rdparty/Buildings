within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model RP1711_6_1
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlants.WaterCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
        pumPri(final nPum=2, final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
      pumSec,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
      pumCon(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.EconomizerSection.None
      eco);

  annotation (
    defaultComponentName="chw");
end RP1711_6_1;