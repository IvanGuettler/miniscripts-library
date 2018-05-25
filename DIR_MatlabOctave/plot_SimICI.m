close all; clear all; clc

	pkg load mapping
	
	figure (1)
		CO=shaperead('./coastline.shp');                 shapedraw(CO,'b'); hold on
		MR=shaperead('./MAJOR_ROAD_NETWORK.shp');        shapedraw(MR,'k'); hold on
		NR=shaperead('./NATIONAL_ROAD_NETWORK.shp');     shapedraw(NR,'r'); hold on
		OI=shaperead('./oilpipel.shp');                  shapedraw(NR,'y'); hold on
		DW=shaperead('./DW_Links.shp');                  shapedraw(DW,'m'); hold on
		VL=shaperead('./voltline.shp');                  shapedraw(VL,'g'); hold on
		PR=shaperead('./portpoly.shp');                  shapedraw(PR, ['c';'c']); hold on
			legend('coastline','roads: major','roads: national','oil pipes','water pipes','electricity lines','Port')
