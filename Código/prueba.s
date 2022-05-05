; Banderas y contadores

TotalPersonas					EQU		0x20000000
PersonasTempAlta				EQU		0x20000004
DetectarPersona					EQU		0x20000008
UbicacionMedicion				EQU		0x2000000C
DiaTerminado					EQU		0x20000010
TempBandera						EQU		0x20000014
CambioTerminal					EQU		0x20000018
TemperaturaMedida				EQU		0x2000001C
MandarDatosBandera				EQU		0x20000020

	
	PRESERVE8
    THUMB

    AREA RESET, DATA, READONLY

    EXPORT __Vectors

__Vectors    DCD 0x2000200
            DCD Reset_Handler

            ALIGN

            AREA MYCODE, CODE, READONLY
            ENTRY
            EXPORT Reset_Handler

;R0: Contador
;R1: Valor de memoria
;R2: Puntero
;R3: Bandera para reset

Reset_Handler

		;inicializar valores
		MOV		R0,#0 ;contador empieza en 0
		MOV		R1,#0 ;ningun valor de memoria asignado todavía
		MOV		R2,#0 ;ningun puntero asignado todavía
		MOV		R3,#0 ;no se debe hacer un reset todavía
		
		;Total de personas medidas:
		LDR		R2,=TotalPersonas ;total de personas medidas es = 0
		STR		R1, [R2] ;actualiza el estado R1 de TotalPersonas al que apunta R2
		
		;Total de personas medidas con temperatura mayor a 38.7 grados Celsius.
		LDR		R2,=PersonasTempAlta ;total de personas medidas es = 0
		STR		R1, [R2] ;actualiza el estado R1 de PersonasTempAlta al que apunta R2
		
		;Dia terminado:
		LDR		R2,=DiaTerminado ;dia no ha terminado entonces es = 0
		STR		R1, [R2] ;actualiza el estado R1 de DiaTerminado al que apunta R2
		
		;Ubicacion asociada a la medicion:
		LDR		R2,=UbicacionMedicion ;ubicacion inicial es = 0
		STR		R1, [R2] ;actualiza el estado R1 de UbicacionMedicion al que apunta R2
		
		;Bandera que indica que ha cambiado la ubicacion:
		LDR		R2,=CambioTerminal ;no ha cambiado de ubicacion entonces es = 0
		STR		R1, [R2] ;actualiza el estado R1 de CambioTerminal al que apunta R2

VerificarLugar
		LDR		R2,=CambioTerminal
		LDR		R1, [R2]
		B		CambioUbicacion

ResetMedicion
	
		;inicializar valores
		MOV		R0,#0 ;contador empieza en 0
		MOV		R1,#0 ;ningun valor de memoria asignado todavía
		MOV		R2,#0 ;ningun puntero asignado todavía
		MOV		R3,#0 ;no se debe hacer un reset todavía

		;Persona detectada:
		LDR		R2,=DetectarPersona ;persona detectada es = 0
		STR		R1, [R2] ;actualiza el estado R1 de DetectarPersona al que apunta R2
		
		;Bandera asociada a la temperatura:
		LDR		R2,=TempBandera ;temp inicial es = 0
		STR		R1, [R2] ;actualiza el estado R1 de TempBandera al que apunta R2
		
		;Bandera asociada a mandar datos
		LDR		R2,=MandarDatosBandera ;bandera inicial es = 0
		STR		R1, [R2] ;actualiza el estado R1 de MandarDatosBandera al que apunta R2
		
Main
		
		LDR		R2,=DetectarPersona
		LDR		R1, [R2] ;actualiza el estado R1 de DetectarPersona al que apunta R2
		
		CMP		R1, #1
		BEQ		Medicion
		
		B		Main

Medicion
		
		LDR		R2,=TemperaturaMedida
		LDR		R1, [R2]
		
		CMP		R1, #64
		BGT		TemperaturaAlta
		
		B		TemperaturaNoAlta

TemperaturaAlta
		
		;Bandera asociada a la temperatura:
		LDR		R2,=TempBandera
		STR		R1, [R2] ;actualiza el estado R1 de TempBandera al que apunta R2
		
		;Total de personas medidas:
		LDR		R2,=TotalPersonas ;total de personas medidas es = 0
		LDR		R1, [R2] ;actualiza el estado R1 de TotalPersonas al que apunta R2
		
		ADD		R1, R1, #1
		STR		R1, [R2]
		
		;Total de personas medidas con temperatura mayor a 38.7 grados Celsius.
		LDR		R2,=PersonasTempAlta ;total de personas medidas es = 0
		LDR		R1, [R2] ;actualiza el estado R1 de PersonasTempAlta al que apunta R2
		
		ADD		R1, R1, #1
		STR		R1, [R2]
		
		MOV		R1, #1
		;Bandera asociada a mandar datos
		LDR		R2,=MandarDatosBandera ;bandera inicial es = 0
		STR		R1, [R2] ;actualiza el estado R1 de MandarDatosBandera al que apunta R2
		
		B		VerificarLugar

TemperaturaNoAlta

		;Total de personas medidas:
		LDR		R2,=TotalPersonas ;total de personas medidas es = 0
		LDR		R1, [R2] ;actualiza el estado R1 de TotalPersonas al que apunta R2
		
		ADD		R1, R1, #1
		STR		R1, [R2]
		
		MOV		R1, #1
		;Bandera asociada a mandar datos
		LDR		R2,=MandarDatosBandera ;bandera inicial es = 0
		STR		R1, [R2] ;actualiza el estado R1 de MandarDatosBandera al que apunta R2
		
		B		VerificarLugar
		
CambioUbicacion

		CMP 	R1, #0
		BEQ		ResetMedicion
		
		ADD		R1, R1, #1
		
		;Ubicacion asociada a la medicion:
		LDR		R2,=UbicacionMedicion
		STR		R1, [R2] ;actualiza el estado R1 de UbicacionMedicion al que apunta R2
		
		MOV		R1, #0
		;Bandera asociada al cambio de ubicacion:
		LDR		R2,=CambioTerminal
		STR		R1, [R2] ;actualiza el estado R1 de CambioTerminal al que apunta R2
		
		B		ResetMedicion

Retornar
		BX		LR
		
Final
		B 			Final ;Finaliza el programa
		END