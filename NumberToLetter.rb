#Conversión de dígitos a letra para cifras monetarias en Español#
#Desarrollado para Kikoya #
#Author: Diego HD #
#Fecha: 10/06/2020 #

class NumToLetter

	#Método principal: recibe la cifra en número como String
	#la valida, la transforma a letra y regresa la cifra en letra como String.

	#Parámetros: 
		# -> String con la cifra en dígitos (ej. "345678")
		# -> Tipo de cambio/moneda en singular (ej. "PESO" ó "DÓLAR")
		# -> Tipo de cambio/moneda en plural (ej. "PESOS" ó "DÓLARES")

	def DigitToLetterPesos(cifra, monedaSingular, monedaPlural)

	   	#####VALIDACIONES#####
	   	
	   	#1.-Verificar que no sea valor nulo:
		if cifra.nil? 					
			raise 'Parameter Error: valor nulo (Nil)'
		end

		#2.-Verificar que no sea una cadena vacía:
		if cifra.length == 0			
			raise 'Parameter Error: cadena vacía.'
		end

		#Separamos la cifra por puntos para obtener los enteros y los centavos:
	   	enteros_y_centavos= cifra.split(".")

	   	#3.-Verificamos que sólo exita un punto de separación y no más:
	   	if enteros_y_centavos.length > 2
	   		raise 'Parameter Error: existe más de un punto en la cifra'
	   	end

	   	#Asignamos a la variable "cifra" los valores enteros y a la variable "centavos" los centavos,
	   	#también quitamos letras, comas y comillas ('´^`,"), todo los que no sea número:
	   	cifra = enteros_y_centavos[0].split(//).map {|x| x[/\d+/]}.compact.join("").to_s
	   	centavos = enteros_y_centavos[1]
	   	#Verificamos que haya centavos:
	   	if not centavos.nil? 
	   		centavos = centavos.split(//).map {|x| x[/\d+/]}.compact.join("").to_s
	   	end

	   	#En caso de tener un sólo caractér en centavos, le añadimos un cero para que 
	   	#se cuente como decenas en el método auxiliar, i.e., ".1" --> ".10"
	   	#Así, cuando se voltee ("01"), se pueda contar como "DIEZ CENTAVOS": 
	   	if not centavos.nil? and centavos.length == 1 
	   		centavos = centavos + "0"
	   	end

		#4.-Quitar ceros anteriores y letras a primer dígito:
		cifra = cifra.to_i.to_s 		
		
		#Opcional: 
		#5.-Verificar que no hayan escrito puros ceros:
		#if cifra.length == 1 and cifra.to_i == 0	
		#	raise 'Parameter Error: la cifra es cero y debe ser mayor a cero.'
		#end

		#Define si la moneda deber ir en singular o en plural, debe ser antes del reverse:
		if cifra.to_i == 1 
			moneda = monedaSingular #"PESO"
		else
			moneda = monedaPlural #"PESOS"
		end

		#Voltea la cadena para tener una mejor manipulación de las cifras:
		cifra = cifra.reverse

		#Divide en grupos de 3 digitos y lo guarda en orden en el arreglo:
		a = ""
		arr = []
		for i in 0...cifra.length do
			if (i+1)%3 == 0 then
				a = a + cifra[i]
				arr.push(a)
				a = ""
			else
				a = a + cifra[i]
			end
		end
		if not a.empty? then
			arr.push(a)
			a = ""
		end

		#Cada 3 dígitos de atrás para adelante manda a llamar al método auxiliar
		#que convierte unidades, decenas, centenas en letra y dependiendo la 
		#posición de esa tercia de dígitos le agrega la mil, millones, billones, miles de trillones:
		str=""
		for j in 0...arr.length do
			case j
				when 0
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + str
				when 1
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + " MIL " + str
				when 2
					if arr[j].length == 1 and arr[j].to_s.to_i == 1
						b = " MILLÓN "
					else
						b = " MILLONES "
					end

					cf = cifra.reverse[-6..-1]
					band = true
					i = 0
					while i<6 and band do
						if cifra[i].to_i != 0
							band = false
						end
						i = i + 1
					end
					if i==6
						str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + b + "DE "
					else
						str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + b + str
					end

				when 3
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + " MIL " + str
				when 4
					if arr[j].length == 1 and arr[j].to_s.to_i == 1
						b = " BILLÓN "
					else
						b = " BILLONES "
					end
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + b + str
				when 5
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + " MIL " + str
				when 6
					if arr[j].length == 1 and arr[j].to_s.to_i == 1
						b = " TRILLÓN "
					else
						b = " TRILLONES "
					end
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + b + str
				when 7
					str = self.ThreeDigitsToLetter(arr[j].to_s).to_s + " MIL " + str
				else
					str = "EXCEDE LOS MILES DE TRILLONES"
			end
		end

		if centavos.nil? 
			cents = ""
		elsif centavos[0].to_s.to_i == 0 and (centavos[1].to_s.to_i == 0 or centavos[1].nil?)
			cents = ""
		#Con esto nos aseguramos que sea 01 centavos y con esto coloquemos "CENTAVO" específicamente:
		elsif centavos[0].to_s.to_i == 0 and centavos[1].to_s.to_i == 1
			cents = " CENTAVO"
		#De cuaqluier otra forma será centavos:
		else
			cents = " CENTAVOS"
		end

		#Concatena la cifra en letra con la moneda en singular o plural según corresponda
		#y asegura que sólo haya un espacio de separación.
		#Además, pregunta si hay centavos y los agrega en caso de afirmativo:
		
		#Si ya tiene espacio:
		if str[-1] == " "		
			#Si no tiene centavos:	
			if centavos.nil?	
				str = str + moneda
			#Si sus centavos son ceros ej. 3.0 ó 45.00:	
			elsif centavos[0].to_s.to_i == 0 and (centavos[1].to_s.to_i == 0 or centavos[1].nil?)
				str = str + " " + moneda
			#Si sí tiene centavos:
			else 					
				#Gracias a que pedimos el substring de dos espacios, se obliga a que haya decenas y undidades,
				#de tal forma que 8.1 sea "OCHO PESOS CON DIEZ CENTAVOS" y no "UN CENTAVO":
				str = str + moneda + " CON " + self.ThreeDigitsToLetter(centavos[0..1].to_s.reverse) + cents
			end
		#Si aún no tiene espacio:
		else 			
			#Si no tiene centavos:				
			if centavos.nil? 				
				str = str + " " + moneda
			#Si sus centavos son ceros ej. 3.0 ó 45.00:	
			elsif centavos[0].to_s.to_i == 0 and (centavos[1].to_s.to_i == 0 or centavos[1].nil?)
				str = str + " " + moneda
			#Si sí tiene centavos:
			else 						
				str = str + " " + moneda + " CON " + self.ThreeDigitsToLetter(centavos[0..1].to_s.reverse) + cents
			end	
		end
		#Nota: centavos[0..1] nos devuelve un string de 

		#Regresa la cadena (String) con el resultado final:
		return str

	end #End método principal: DigitToLetterPesos
		

	#Método auxiliar: transforma tres dígitos (String) por unidades, decenas, centenas 
	#a letra y regresa esa cifra de 3 dígitos en letra (String).
	def ThreeDigitsToLetter(x)
		str = ""
		dec = ""
		cent = ""
			#Recorre cada dígito de los la cifra de 1-3:
			for j in 1..x.length do

				#UNIDADES
				if j == 1 
					case x[0].to_i
					when 0 
						if x.length == 1
							str = "CERO"
						else
							str = ""
						end
					when 1 
						str = "UN"
					when 2
						str = "DOS"
					when 3 
						str = "TRES"
					when 4
						str = "CUATRO"
					when 5 
						str = "CINCO"
					when 6
						str = "SEIS"
					when 7 
						str = "SIETE"
					when 8
						str = "OCHO"
					when 9 
						str = "NUEVE"
					else 
						str = "¡¡¡Error en las unidades!!!"
					end

				#DECENAS
				elsif j == 2
					case x[1].to_i

						#DECENAS
						when 0
							str = str
						when 1					#(DE ONCE A DIECINUEVE)
							case x[0].to_i
								when 0 
									str = "DIEZ"
								when 1 
									str = "ONCE"
								when 2
									str = "DOCE"
								when 3 
									str = "TRECE"
								when 4
									str = "CATORCE"
								when 5 
									str = "QUINCE"
								when 6
									str = "DIECISÉIS"
								when 7 
									str = "DIECISIETE"
								when 8
									str = "DIECIOCHO"
								when 9 
									str = "DIECINUEVE"
								else 
									str = "¡¡¡Error en decenas en los diecis!!!"
							end

						when 2						#(VEINTES)
							case x[0].to_i
								when 0 
									str = "VEINTE"
								when 1 
									str = "VEINTIUNO"
								when 2
									str = "VEINTIDÓS"
								when 3 
									str = "VEINTITRÉS"
								when 4
									str = "VEINTICUATRO"
								when 5 
									str = "VEINTICINCO"
								when 6
									str = "VEINTISÉIS"
								when 7 
									str = "VEINTISIETE"
								when 8
									str = "VEINTIOCHO"
								when 9 
									str = "VEINTINUEVE"
								else 
									str = "¡¡¡Error en decenas en los veintes!!!"
							end

						#DECENAS (30-90)
						when 3
							dec = "TREINTA"
						when 4
							dec = "CUARENTA"
						when 5
							dec = "CINCUENTA"
						when 6
							dec = "SESENTA"
						when 7
							dec = "SETENTA"
						when 8
							dec = "OCHENTA"
						when 9
							dec = "NOVENTA"
						else
							dec = "¡¡¡Error en decenas (30-90)!!!"
					end
					#Ajuste, si la unidad era CERO, pero la decena no, o si la decena es 1 ó 2 ó 0,
					#en ese caso, se reescribe toda la cadena. De lo contrario se coloca un "Y" y la unidad:
					if x[1].to_i == 0 or x[1].to_i == 1  or  x[1].to_i ==2
						str = str
					elsif x[0].to_i == 0 
						str = dec
					else
						str = dec + " Y " + str
					end

				#CENTENAS	
				elsif j == 3
					case x[2].to_i 
						when 0
							cent = ""
						when 1 
							if x[0].to_i == 0 and x[1].to_i == 0
								cent = "CIEN"
							else
								cent = "CIENTO"
							end
						when 2
							cent = "DOSCIENTOS"
						when 3
							cent = "TRESCIENTOS"
						when 4
							cent = "CUATROCIENTOS"
						when 5
							cent = "QUINIENTOS" 
						when 6
							cent = "SEISCIENTOS"
						when 7
							cent = "SETECIENTOS"
						when 8
							cent = "OCHOCIENTOS" 
						when 9
							cent = "NOVECIENTOS"
						else
							cent = "¡¡¡ Error en centenas !!!"
					end
					#Verifica los espacios:
					if x[0].to_i == 0 and x[1].to_i == 0
						str = cent + str
					elsif x[2].to_i != 0
						str = cent + " " + str
					end
				end
			end
		#Regresa la cadena con la cifra de 3 en letra:
		return str

	end #End método auxiliar: ThreeDigitsToLetter

end #End Class


###############################################################

#Main para tests manuales:
if __FILE__ == $0

	print 'c: '
	cifra = gets

	while cifra != "x"
		num = NumToLetter.new{}
		st = num.DigitToLetterPesos(cifra, "PESO", "PESOS")
  		print "l: " + st.to_s + "\n"
  		print 'c: '
		cifra = gets
	end

end
