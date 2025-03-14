create database Funciones;
use Funciones;

select * from orders;

#----------Ejercicio 1----------:
delimiter //
create function ejercicioUno(fechaDesde date,fechaHasta date, estado text) returns int deterministic
begin
	declare ordenes int;
    set ordenes = (select count(*) from orders where orderDate < fechaHasta and orderDate > fechaDesde and status = estado);
    return ordenes;

end//
delimiter ;

select ejercicioUno("2004-03-25", "2004-08-02", "Shipped");

#----------Ejercicio 2----------:
delimiter //
create function ejercicioDos(fechaInicio date, fechaFin date) returns int deterministic
begin
	declare ordenes int;
	set ordenes = (select count(*) from orders where shippedDate > fechaInicio and shippedDate < fechaFin and status = "Shipped");
	return ordenes;
end//
delimiter ;

select ejercicioDos("2004-03-25", "2004-08-02");

#----------Ejercicio 3----------:
select * from customers;
select * from employees;
select * from offices;

delimiter //
create function ciudadEmpleado(numeroCliente int) returns text deterministic
begin
	declare ciudad text;
    set ciudad = (select offices.city from offices 
    join employees on employees.officeCode = offices.officeCode
    join customers on employeeNumber = salesRepEmployeeNumber
    where customerNumber = numeroCliente);
    return ciudad;
end//
delimiter ;

select ciudadEmpleado(112);

#----------Ejercicio 4----------:
delimiter //
create function productLines (linea text) returns int deterministic
begin
	declare productos int;
	set productos = (select count(*) from products where productLine = linea);
    return productos;
end//
delimiter ;

select productLines("Classic Cars");

#----------Ejercicio 5----------:
delimiter //
create function clientesPorOficina (codigo int) returns int deterministic
begin
	declare clientes int;
    set clientes = (select count(*) from customers 
    join employees on employeeNumber = salesRepEmployeeNumber
    where officeCode = codigo);
    return clientes;
end//
delimiter ;

select clientesPorOficina(4);
select * from offices;

#----------Ejercicio 6----------:
delimiter //
create function ordenesPorOficina(codigo int) returns int deterministic
begin
	declare ordenes int;
    set ordenes = (select count(*) from orders
    join customers on orders.customerNumber = customers.customerNumber
    join employees on employeeNumber = salesRepEmployeeNumber
    where officeCode = codigo);
    return ordenes;
end//
delimiter ;

select ordenesPorOficina(1);

#----------Ejercicio 7----------:
delimiter //
create function beneficios(numeroOrden int, numeroProducto text)returns int deterministic
begin
	declare beneficio int;
    set beneficio = (select priceEach - buyPrice from orderdetails 
    join products on products.productCode = orderdetails.productCode
    where orderNumber = numeroOrden and products.productCode = numeroProducto);
    return beneficio;
end//
delimiter ;

select beneficios(10100, "S18_1749");

#----------Ejercicio 8----------:
delimiter //
create function ordenCancelada(numeroOrden int) returns int deterministic
begin
	declare orden int;
    
    if (select status from orders where orderNumber = numeroOrden) = "Cancelled" then
		set orden = -1;
    else
		set orden = 0;
	end if;
    
	return orden;
end//
delimiter ;

select ordenCancelada(10167);

#----------Ejercicio 9----------:
delimiter //
create function primeraOrden(numeroCliente int)returns date deterministic
begin
	declare fecha date;
	set fecha = (select orderDate from orders join
    customers on customers.customerNumber = orders.customerNumber
    where customers.customerNumber = numeroCliente order by orderDate asc limit 1);
    return fecha;
end//
delimiter ;

drop function primeraOrden;
select primeraOrden(103);

#----------Ejercicio 10----------:
delimiter //
create function ejercicioDiez(productoCodigo text) returns int deterministic
begin
	declare cantidad int;
    declare total int;
    declare porcentage int;
    
    set cantidad = (select count(*) from orderdetails 
    join products on orderdetails.productCode = products.productCode
    where MSRP > priceEach and products.productCode = productoCodigo);
    set total = (select count(*) from orderdetails where productCode = productoCodigo);
    
    set porcentage = 100*(cantidad/total);
    
    return porcentage;
end //
delimiter ;

drop function ejercicioDiez;
select * from products;
select ejercicioDiez ("S18_1589");

#----------Ejercicio 11----------:
delimiter //
create function fechaProducto(productoCodigo text)returns date deterministic
begin
	declare fecha date;
    
    set fecha = (select orderDate from orders
    join orderdetails on orders.orderNumber = orderdetails.orderNumber
    where orderdetails.productCode = productoCodigo order by orderDate desc limit 1);
    
    return fecha;
end//
delimiter ;

drop function fechaProducto;
select fechaProducto("S10_1678");

#----------Ejercicio 12----------:
delimiter //
create function productosOrdenados(fechaInicio date, fechaFin date, productoCodigo text)returns float deterministic
begin
	declare resultado float;
	
    if exists(select orderDate from orders
    join orderdetails on orders.orderNumber = orderdetails.orderNumber
    where orderDate > fechaInicio and orderDate < fechaFin and productCode = productoCodigo) then
		set resultado = (select max(priceEach) from orderdetails
        join orders on orders.orderNumber = orderdetails.orderNumber
        where orderDate > fechaInicio and orderDate < fechaFin and productCode = productoCodigo);
	else
		set resultado = 0;
	end if;
    
	return resultado;
end//
delimiter ;

select productosOrdenados("2003-03-25", "2005-08-02", "S12_1666");

#----------Ejercicio 13----------:
delimiter //
create function cantidadClientes(empleadoCodigo int)returns int deterministic
begin
	declare clientes int;
    
	set clientes = (select count(*) from customers where salesRepEmployeeNumber = empleadoCodigo);
    
    return clientes;
end//
delimiter ;

select cantidadClientes(1621);
#----------Ejercicio 14----------:
delimiter //
create function apellidoEmpleado(empleadoCodigo int)returns text deterministic
begin
	declare apellido text;
    set apellido = (select lastName from employees where employeeNumber = empleadoCodigo);
    return apellido;
end//
delimiter ;

select * from employees;
select apellidoEmpleado(1621);
