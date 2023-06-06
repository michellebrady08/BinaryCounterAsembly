# Laboratorio 6

## Práctica de laboratorio N. 6

Creado por: Andrea Michelle Brady Chávez 

Matrícula: 2213026363

### Objetivo

El objetivo de está práctica es el de diseñar un contador binario de 10 bits que a la salida muestra el valor de la cuenta en 10 ledes. El contador aumenta su cuenta cada segundo de forma prdeterminada. Al oprimir un botón, el contador cambiará su modo y trabajará en modo descendente. Si el botón vuelve a presionarse, entonces el contador regresará al modo ascendente. A su vez, el contador podrá aumentar su velocidad x2, x4 y x8 al oprimir un segundo botón. La velocidad regresará a x1 cuando ésta esté establecida en x8 y el usuario oprima nuevamente el segundo botón.

## Descripción de los archivos del proyecto

### main.s

El archivo "main.s" contiene la lógica principal del programa, donde se realizan las configuraciones de los periféricos, la inicialización de las variables, el manejo de la velocidad y el modo de conteo, y la visualización del valor actual del contador en los ledes. También se hace uso de las funciones "Systick_Initialize()" para configurar el temporizador SysTick y "check_speed()" para determinar el retardo en función de la velocidad seleccionada.

Contiene las configuraciones de los perfiféricos, la inicialización de las variables, llamado a la función `check_speed()`,  la logica de incremento y decremento y el llamado a la función `delay()`

En C se puede apreciar de la siguiente forma

```c
int main(){
    // Enable clock for Port B
    RCC_APB2ENR = 8;
    EXTI_0_3_Initialize();
		SysTick_Initialize();
		counter = 0;
		speed = 1;
		mode = 0;

    while (){
        delay = check_speed();
		if(mode != 0){
			counter ++;
		}
		else{
			counter --;
		}
		output(counter);
		wait(delay);	
	}
return 0;
}
```

En el bucle infinito primero checamos la velocidad de la interrupción, y la almacenamos en delay, seguimos con la logica del incremento o decremento checando el valor de modo, para finalizar mostrando en los leds el valor actual de counter, finalmente llama a delay para realizar el retardo.

### `Systick_initialize();`

la función Systick_initialize() va a configurar la interrupción de SysTick, que sigue la siguiente lógica en C.

```c
void SysTick_Initialize(){
	Systick->CTRL = 0;
	SysTick->LOAD = 1000;
	SysTick->VAL = 0;
	Systick->CRL = 7;
}
```

Este código configura el registro de control del temporizador SysTick en un microcontrolador. 

Sigue la siguiente lógica:

1. Se carga la dirección base de SysTick en el registro r0 utilizando la instrucción `ldr`. La dirección base se refiere a la ubicación de los registros de control del temporizador SysTick en la memoria.

2. Se almacena el valor 0x0 en la dirección [r0, STK_CTRL_OFFSET]. Esta operación deshabilita la interrupción SysTick y el contador SysTick, y selecciona el reloj externo como fuente de temporización.

3. Se carga el valor 1000 en el registro r5 utilizando la instrucción `ldr`. Este valor representa el número de ciclos de reloj entre dos interrupciones de SysTick. Puede ajustarse según el intervalo de interrupción deseado.

4. Se almacena el valor 1000 en la dirección [r0, STK_LOAD_OFFSET]. Este valor se guarda en el registro de recarga SysTick y especifica el número de ciclos de reloj entre dos interrupciones.

5. Se almacena el valor 0 en la dirección [r0, STK_VAL_OFFSET]. Esta operación escribe el valor 0 en el registro de valor actual de SysTick, lo que significa que el contador SysTick comenzará desde cero cuando se habilite.

6. Se realiza una operación OR entre el valor actual del registro de control y 7 (0b111) utilizando la instrucción `orr`. Esto establece los bits de enable y interrupt en 1, lo que habilita el temporizador SysTick y las interrupciones de SysTick.

7. Se almacena el nuevo valor del registro de control en la dirección [r0, STK_CTRL_OFFSET]. Esta operación habilita el temporizador SysTick y las interrupciones de SysTick.

En resumen, el código configura el temporizador SysTick para generar interrupciones periódicas utilizando un intervalo especificado. Deshabilita inicialmente el temporizador y las interrupciones, configura el intervalo de tiempo deseado, borra el contador actual y luego habilita el temporizador y las interrupciones.

### `EXTIx_Initialize();`

Laa función de EXTIx_Initialize() contiene la configuración para las interrupciones externas EXTI0 y EXTI3.

```c
void EXTIx_Initialize(){
	AFIO->EXTICR3 = 0x0;
	EFIO->FTST = 0x0;
	// Se usa un 0xC00 para habilitar el Rising Edge en los bits que pertenecen al 11 y 10 
	EFIO->RTST = 0xC00;
	EFIO->IMR = 0xC00;

	// Para activar la interrupción EXTI15-10 se enciende el bit en la posición 8
	NVIC->ISER1 = 0x100;
}
```
<img width="703" alt="image" src="https://github.com/michellebrady08/Laboratorio6/assets/110513243/d92def84-d1a0-47e0-9e74-6fa477f061ab">

```

Este código configura las fuentes de disparo (trigger sources) y los bordes de activación/desactivación (rising/falling edges) para las interrupciones EXTI 10 y EXTI 11 en un microcontrolador. 

Sigue la siguiente lógica:

1. Se carga la dirección base de AFIO (Alternate Function I/O) en el registro r0 utilizando la instrucción `ldr`. AFIO es un bloque en el microcontrolador que permite asignar las funciones de los pines de E/S alternativas.

2. Se almacena el valor de r1 en la dirección [r0, AFIO_EXTICR1_OFFSET]. Este valor configura los bits correspondientes a EXTI 11 y EXTI 10 en el registro AFIO_EXTICR3, seleccionando los pines PA.10 y PA.11 como fuentes de disparo para las interrupciones EXTI 11 y EXTI 10 respectivamente.

3. Se carga la dirección base de EXTI (External Interrupt/Event Controller) en el registro r0 utilizando la instrucción `ldr`.

4. Se realiza una operación XOR exclusiva (eor) entre el registro r1 y sí mismo, lo que establece todos los bits en r1 en 0. Este valor se utiliza para desactivar el disparo de flanco ascendente (rising edge trigger) para las interrupciones EXTI 10 y EXTI 11.

5. Se almacena el valor de r1 en la dirección [r0, EXTI_FTST_OFFSET]. Esta operación deshabilita el disparo de flanco ascendente para las interrupciones EXTI 10 y EXTI 11.

6. Se carga el valor 0xC00 en el registro r1 utilizando la instrucción `ldr`. Este valor representa una máscara de bits que corresponde a los bits de EXTI 10 y EXTI 11 en los registros de activación de flanco descendente (falling edge trigger).

7. Se almacena el valor de r1 en las direcciones [r0, EXTI_RTST_OFFSET] y [r0, EXTI_IMR_OFFSET]. Estas operaciones deshabilitan el disparo de flanco descendente y también deshabilitan la interrupción EXTI 10 y EXTI 11 respectivamente.

8. Se carga la dirección base de NVIC (Nested Vectored Interrupt Controller) en el registro r0 utilizando la instrucción `ldr`. NVIC es un componente en el microcontrolador que maneja las interrupciones.

9. Se realiza una operación OR (orr) entre el valor actual de r1 y 0x100. Esto establece el bit de habilitación (enable bit) en 1 para la interrupción EXTI 15-10, que se encuentra en el bit 8 del registro NVIC_ISER1 y lo mismo para el EXTI 0.

El código configura las fuentes de disparo y los bordes de activación/desactivación para las interrupciones EXTI 10 y EXTI 11. Establece los pines PA.11 y PA.10 como fuentes de disparo para EXTI 11 y EXTI 10 respectivamente, y habilita la interrupción EXTI 11 y EXTI 10 en el controlador NVIC.

### Systick_handler.s

Las funciones "Systick_Handler()" y "Delay()" se encargan de generar la espera de 1 segundo mediante el decremento de una variable de retardo.

Función sencilla solo decrementa el valor de delay, para generar la espera de 1 segundo.

```c
void Systick_Handler(){
	delay --;
}
```

### Delay.s

Este archivo contiene la función del delay, es muy sencilla, recibe el valor del “delay” que se desea, checa si el valor de este es distinto de 0, y no se detiene hasta que este llegue a cero.

```c
void Delay(int delay){
	while(delay != 0);
}
```

### cheeck_speed.s

Este archivo almacena la función que checa la velocidad que se solicita para el contador y regresa el valor del delay

```c
int check_speed(int speed){
	if speed ==1;
		return 1000; 
	else if speed == 2;
		return 500;
	else if speed == 4;
		return 250;
	else if speed == 8;
		return 125;
	else{ 
		speed = 1;
		return 1000; 
	}
}
```

### EXTI10-11_Handler.s

Este archivo almacena 3 funciones, la función `EXTI15_10_Handler();`, y las dos funciones que manejan cada respectiva interrupción:

Contiene las funciones que se ejecutan cuando se producen las interrupciones EXTI 10 y EXTI 11. La función "EXTI15_10_Handler()" determina cuál de las dos interrupciones se ejecutó y llama a la función correspondiente. La función "EXTI10_Handler()" altera la velocidad del contador al presionar un botón, mientras que la función "EXTI11_Handler()" cambia el modo de conteo.

### EXTI15_10_Handler();

Esta funcion determina que interrupción se va a ejecutar leyendo los valores almacenados el los pines que se configuraron para la interrupción, estps pines están conectados a un push button.

```c
void EXTI15_10_Handler(void) {

    if (EXTI_PR_PR10 != 0) {
        // EXTI0 interrupt occurred
        EXTI10_Handler();
    } else if ( EXTI_PR_PR11 != 0) {
        // EXTI11 interrupt occurred
        EXTI11_Handler();
    }
}
```

### `EXTI10_Handler();`

Esta función es la que ocurre al presionar el pin A10, la lógica de este botón es la de alterar la velocidad de nuestro contador cada que se presiona el botón.

```c
void EXTI10_Handler(){
	if(speed != 8){
		speed = speed*2;	
	}
	else{
		speed = 1;
	}
}
```

### `EXTI11_Handler();`

Está función es la que ocurre al presionar el pin A11, la lógica de esta interrupción es la de cambiar el modo.

```c
void EXTI11_Handler(){
	mode = !mode;
	mode &= 1;
}
```

## Conclusión

El archivo del proyecto muestra la implementación de un contador binario de 10 bits con funcionalidades adicionales de cambio de modo y ajuste de velocidad. El código proporcionado configura los periféricos, maneja las interrupciones y controla el contador, brindando una solución completa para el objetivo establecido en la práctica de laboratorio.

