#Conversión de dígitos a letra para cifras monetarias #
#Desarrollado para Kikoya #
#Author: Diego HD #
#Fecha: 10/06/2020 #

class NumToLetter

	def DigitToLetterPesos(cifra)
		a = ""
		arr = []

		#AGREGAR "PESO" O "PESOS" AL FINAL
		if cifra.to_i == 1 
			puts 'b'
			moneda = "PESO"
		else
			moneda = "PESOS"
		end

		#Turn around the String number for an easier manipulation:
		cifra = cifra.reverse

		#Divide in groups of 3 digits and save in order in an array:
		for i in 1...cifra.length do
			if i%3 == 0 then
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

		str=""
		cont = 0

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
						puts i
						if cifra[i].to_i != 0
							band = false
						end
						i = i + 1
					end
					puts cf
					puts band
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

		if str[-1] == " "
			str = str + moneda
		else
			str = str + " " + moneda
		end

		return str
	end
		
	def ThreeDigitsToLetter(x)
		str = ""

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
						str = ""
					end

				#DECENAS
				elsif j == 2
					dec = ""
					cent = ""
					case x[1].to_i

						#ONCE-DIECINUEVE
						when 0
							str = str
						when 1
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
									str = "¡¡¡ Error en decenas en los diecis !!!"
							end

						when 2
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
									str = "¡¡¡ Error en decenas en los veintes!!!"
							end

						
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
							dec = "¡¡¡ Error en decenas !!!"
					end
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
					if x[0].to_i == 0 and x[1].to_i == 0
						str = cent + str
					elsif x[2].to_i != 0
						str = cent + " " + str
					end

				end

			end
		return str
	end

end #End Class

#####################

#Main:
if __FILE__ == $0

	print 'c: '
	cifra = gets

	while cifra != 'x'
		num = NumToLetter.new{}
		st = num.DigitToLetterPesos(cifra.to_s)
  		print "l: " + st.to_s + "\n"
  		print 'c: '
		cifra = gets
	end
end


