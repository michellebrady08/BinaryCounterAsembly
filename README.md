# Laboratorio 6

## Práctica de laboratorio N. 6

Creado por: Andrea Michelle Brady Chávez 

Matrícula: 2213026363

### Objetivo

El objetivo de está práctica es el de diseñar un contador binario de 10 bits que a la salida muestra el valor de la cuenta en 10 ledes. El contador aumenta su cuenta cada segundo de forma prdeterminada. Al oprimir un botón, el contador cambiará su modo y trabajará en modo descendente. Si el botón vuelve a presionarse, entonces el contador regresará al modo ascendente. A su vez, el contador podrá aumentar su velocidad x2, x4 y x8 al oprimir un segundo botón. La velocidad regresará a x1 cuando ésta esté establecida en x8 y el usuario oprima nuevamente el segundo botón.

## Descripción de los archivos del proyecto

### main.s

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

### `EXTIx_Initialize();`

Laa función de EXTIx_Initialize() contiene la configuración para las interrupciones externas EXTI0 y EXTI3.

```c
void EXTIx_Initialize(){
	RCC->APB2ENR |= 1;
	AFIO->EXTICR1 = 0;
	EFIO->FTST = 0;
	// Se usa un 9 para habilitar el Rising Edge en los bits 1001 (0 y 3)
	EFIO->RTST = 9;
	EFIO->IMR = 9;

	// Para activar la interrupción se encienden los bits 0010 0100 0000
	NVIC->ISER0 = 576;
}
```

### Systick_handler.s

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

### EXTI0-3_Handler.s

Este archivo almacena 3 funciones, la función `EXTI0_3_Handler();`, y las dos funciones que manejan cada respectiva interrupción:

### `**EXTI0_3_Handler();**`

Esta funcion determina que interrupción se va a ejecutar leyendo los valores almacenados el los pines que se configuraron para la interrupción, estps pines están conectados a un push button.

```c
void EXTI0_3_Handler(void) {

    if (EXTI_PR_PR0 != 0) {
        // EXTI0 interrupt occurred
        EXTI0_Handler();
    } else if ( EXTI_PR_PR3 != 0) {
        // EXTI3 interrupt occurred
        EXTI3_Handler();
    }
}
```

### `EXTI0_Handler();`

Esta función es la que ocurre al presionar el pin B0, la lógica de este botón es la de alterar la velocidad de nuestro contador cada que se presiona el botón.

```c
void EXTI0_Handler(){
	if(speed != 8){
		speed = speed*2;	
	}
	else{
		speed = 1;
	}
}
```

### `EXTI3_Handler();`

Está función es la que ocurre al presionar el pin B3, la lógica de esta interrupción es la de cambiar el modo.

```c
void EXTI3_Handler(){
	mode = !mode;
}
```
