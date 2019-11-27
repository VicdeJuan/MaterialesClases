# encoding: utf-8
from fractions import Fraction
import functools 

def gcd(a,b):
    """Compute the greatest common divisor of a and b"""
    while b > 0:
        a, b = b, a % b
    return a
    
def lcm(a, b):
    """Compute the lowest common multiple of a and b"""
    return a * b / gcd(a, b)


datos_Font=dict({'unit': "minutos",'total': None, 'data': dict({'f1':{'T':Fraction(3,8), 'd':None, 'name': "f1"} ,'f2' : {'R':Fraction(2,5),'T':None, 'd':None,'name': "f2"}, 'f3': {'T':None, 'd':15,'name': "f3"}})})

datos_PDM=dict({'unit':"euros", 'total': None, 'data':dict({'f1P':{'T':Fraction(3,7), 'd':None,'name': "Pepe"} ,'f2D' : {'R':Fraction(3,5),'T':None, 'd':None,'name': "Domingo"}, 'f3M': {'T':None, 'd':8,'name': "Manolo"}})})

datos_Naranjas=dict({'unit': "Naranjas",'total': None, 'data': dict({'f1M':{'T':Fraction(3,4), 'd':None,'name': "Mañana"} ,'f2T' : {'R':Fraction(4,5),'T':None, 'd':None,'name': "Tarde"}, 'f3M': {'T':None, 'd':100,'name': "Sobran"}})})

datos_Dinero=dict({'unit':"Euros", 'total':None, 'data':dict({'f1D':{'T':Fraction(3,4), 'd':None,'name': "Mañana"} ,'f2T' : {'R':Fraction(4,5),'T':None, 'd':None,'name': "Tarde"}, 'f3M': {'T':None, 'd':100,'name': "Sobran"}})})

#datos_edificio=dict({'unit':"Euros", 'total':None, 'data': dict({'f1D':{'T':Fraction(2,5), 'd':None,'name': "Combustible"} ,'f2T' : {'T':Fraction(1,8), 'd':None,'name': "Electricidad"}, 'f3M': {'T':Fraction(1,1)2, 'd':None,'name': "Basuras"},'f4O': {'T':Fraction(1,4), 'd':None,'name': "Mantenimiento"},'f5O': {'T':None, 'd':None,'name': "Limpieza"}})})

datos=datos_PDM






###### DEFINICIÓN DE FUNCIONES AUXILIARES
def check_data(data):
    __KEYS = ['data','total','unit']
    _keys_arg = data.keys()
    _keys_arg.sort()
    return (_keys_arg == __KEYS) and (type(data['data']) == dict)

###### DEFINICIÓN DE VARIABLES
_data = datos['data']
order_keys_list=list(_data.keys())
order_keys_list.sort()


###### CALCULAR FRACCION DE CADA PARTE
# Calculamos la fracción del total que corresponde a cada parte y se almacena dentro del diccionario.
# Recibe el diccionario de datos y devuelve el valor de "reducción a la unidad"

frac_acum=0 # Un contador acumulativo de las partes que se llevan procesadas.
for d in order_keys_list:
    # Según si el dato corresponde al total (T) o al Resto (R)
    if not _data[d].has_key('R'):
        if _data[d]['T'] != None:
            frac_acum += _data[d]['T']
        else:
            # Posible bug: aquí suponemos que estamos en el procesado del último elemento 
            # que corresponde con "lo que queda" después de todo lo que sea 
            # que ocurra en el problema.
            _data[d]['T'] = 1-frac_acum
            
            # Reduccion a la unidad
            if _data[d]['d'] != None:
                unit = _data[d]['T']/_data[d]['d']
            else:
                unit = None
    else:
        _data[d]['T'] = _data[d]['R']*(1-frac_acum)
        frac_acum += _data[d]['T']




###### CALCULAR TOTAL 
if datos['total'] == None and unit != None:    
    # Calculamos el total en unidades.
    datos['total'] = 0
    for d in order_keys_list:
        if _data[d]['d'] == None:
            _data[d]['d'] = _data[d]['T']/unit      
        datos['total'] += _data[d]['d']
        
       
       
##### PRINT FRACCIONES DEL TOTAL
for d in order_keys_list:
    _quantity_str = ""
    if datos['total'] != None:
        _quantity_str = "Corresponde a "+str(_data[d]['T']*datos['total']) + " " +datos['unit'] +"."
    print _data[d]['name'] + ": " + str(_data[d]['T']) + " del total." + _quantity_str 

##### ORDENAR
print
d=datos['data']
#functools.reduce(lambda x,y:lcm(x,y),(lambda a: a['T'].denominator(),datos['data']))

lis = [a[1]['name'] + " (" + str(a[1]['T']) + ")" for a in sorted(d.items(), key=lambda x: x[1]['T'])]
print functools.reduce(lambda x,y:x+" < "+y,lis)
    
##### PRINT TOTAL
print
if datos['total'] != None:
    print "El total es: " + str(datos['total']) + " " + datos['unit']