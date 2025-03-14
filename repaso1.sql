#1
select * from proveedor where ciudad = "La Plata";

#2
delete from articulo where articulo.codigo not in (select articulo_codigo from compuesto_por);

#3
select articulo.codigo, articulo.descripcion from articulo 
join compuesto_por on articulo.codigo = articulo_codigo
where material_codigo in
(select material_codigo from provisto_por 
join proveedor on proveedor_codigo = proveedor.codigo 
where proveedor.nombre = "Lopez SA");

#4
select proveedor.codigo, nombre from proveedor
join provisto_por on proveedor.codigo = proveedor_codigo
where material_codigo in(select material.codigo from material 
join compuesto_por on material.codigo = material_codigo
join articulo on articulo_codigo = articulo.codigo
where precio > 10000);

#5
select codigo from articulo where precio in (select max(precio) from articulo);

#6
select * from articulo where codigo = 
(select articulo_codigo from tiene 
group by articulo_codigo order by sum(stock) desc limit 1);

#7
select almacen_codigo from tiene 
where articulo_codigo in 
(select articulo_codigo from compuesto_por where material_codigo = 2) group by almacen_codigo;

#8
select articulo_codigo, count(material_codigo) as canti from compuesto_por group by articulo_codigo
having canti in 
(select max(cant) from 
(select count(material_codigo) as cant from compuesto_por group by articulo_codigo) as consulta);

#9
update articulo join tiene on articulo.codigo = articulo_codigo set precio = precio*1.2 where stock < 20;

#10
select avg(cant) from (select count(material_codigo) as cant from compuesto_por group by articulo_codigo) as cantm;

#11
select almacen_codigo, avg(precio), max(precio), min(precio) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo;

#12
select almacen_codigo, sum(precio*stock) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo;

#13
select articulo_codigo, sum(precio*stock) from tiene 
join articulo on articulo_codigo = articulo.codigo
where stock > 100
group by articulo_codigo;

#14
select articulo_codigo, count(material_codigo) as cant from compuesto_por group by articulo_codigo having cant > 3;

#15
select material.descripcion from material join compuesto_por on material.codigo = material_codigo
where articulo_codigo in
(select codigo from articulo where precio >
(select avg(precio) from tiene 
join articulo on articulo_codigo = articulo.codigo 
group by almacen_codigo having almacen_codigo = 2)) group by material.descripcion