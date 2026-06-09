
%  read in data from a netcdf file

lon = ncread('in.nc', 'lon');
lat = ncread('in.nc', 'lat');
var = ncread('in.nc', 'var');


%  write out data to a netcdf file

ncid = netcdf.create('out.nc','CLOBBER');

x_dimid = netcdf.defDim(ncid,'lon',length(lon));
y_dimid = netcdf.defDim(ncid,'lat',length(lat));

vid1 = netcdf.defVar(ncid,'lon', 'double',[x_dimid]);
vid2 = netcdf.defVar(ncid,'lat', 'double',[y_dimid]);
vid3 = netcdf.defVar(ncid,'var', 'double',[x_dimid,y_dimid]);

netcdf.putAtt (ncid,vid1,'long_name','variable');

netcdf.endDef(ncid);

netcdf.putVar(ncid, vid1, lon);
netcdf.putVar(ncid, vid2, lat);
netcdf.putVar(ncid, vid3, var);

netcdf.close(ncid);


%  print min and max

disp(sprintf("salt = %f, %f", min(salt,[],'all'),max(salt,[],'all')))

