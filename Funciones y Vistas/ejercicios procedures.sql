#------------Funciones------------:
delimiter //
create function eliminarProducto(codigoOrden int, codigoProducto text) returns int deterministic
begin
	declare cantidad int;
    set cantidad = (select quantityOrdered from orderdetails where orderNumber = codigoOrden and productCode = codigoProducto);
    delete from orderdetails where orderNumber = codigoOrden and productCode = codigoProducto;
		
	return cantidad;
end //
delimiter ;
select eliminarProducto(10100, "S18_1749");


#-----------Ejercicio 1-----------:
delimiter //
create procedure productosCaros()
begin
	select productCode from products where buyPrice > (select avg(buyPrice) from products);
	select count(*) from products where buyPrice > (select avg(buyPrice) from products);
end //
delimiter ;

call productosCaros();
drop procedure productosCaros;


#-----------Ejercicio 2-----------:
delimiter //
create procedure borrarOrden(in codigoProducto text)
begin
	select count(*) from orderdetails where productCode = codigoProducto;
    delete from orderdetails where productCode = codigoProducto;
    delete from products where productCode = codigoProducto;
end //
delimiter ; 

call borrarOrden("S10_1949");

#-----------Ejercicio 3-----------:
select * from productlines;

delimiter //
create procedure borrarLinea(in linea text, out result text)
begin
	if linea in (select productLine from products) then
		set result = "La linea de productos no pudo borrarse porque contiene productos asociados";
	else
		set result = "La linea de productos fue borrada";
        delete from productline where productline = linea;
	end if;
    select result;
end //
delimiter ;

call borrarLinea("Trains", @result);

#-----------Ejercicio 4-----------:
delimiter //
create procedure estado()
begin
	select state, count(*) from orders join customers on orders.customerNumber = customers.customerNumber where state is not null group by state;
end //
delimiter ;

drop procedure estado;
call estado();

#-----------Ejercicio 5-----------:
#-----------Ejercicio 6-----------:


#-----------CURSOR-----------:
#-----------Ejercicio 9-----------:
delimiter //
create procedure getCiudadesOffices(out ciudadesList text)
begin
    declare ciudadObtenida varchar(255) default '';
    declare hayFilas bool default 1;
    
    declare oficinasCursor cursor for 
        select city from offices;

    declare continue handler for not found set hayFilas = 0;

end
//delimiter ;
