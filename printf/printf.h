/**
 @file printf.h

 @brief Small printf, and verious conversion code with floating point support

 @par Copyright &copy; 2015 Mike Gore, GPL License
 @par You are free to use this code under the terms of GPL
   please retain a copy of this notice in any code you use it in.

This is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _PRINTF_H_
#define _PRINTF_H_

#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#ifdef USER_CONFIG
#include "user_config.h"
#endif

// Named address space
#ifndef MEMSPACE
#define MEMSPACE /**/
#endif

// Weak attribute
#ifndef WEAK_ATR
#define WEAK_ATR __attribute__((weak))
#endif

typedef struct _printf_t
{
    void (*put)(struct _printf_t *, char);
    void *buffer;
    int len;
	int size;
} printf_t;


/* printf.c */
MEMSPACE size_t WEAK_ATR strlen ( const char *str );
#undef isdigit
MEMSPACE int WEAK_ATR isdigit ( int c );
MEMSPACE void WEAK_ATR reverse ( char *str );
MEMSPACE void WEAK_ATR strupper ( char *str );
MEMSPACE double WEAK_ATR iexp ( double num , int exp );
MEMSPACE double WEAK_ATR scale10 ( double num , int *exp );
MEMSPACE int p_itoa ( long num , char *str , int max , int prec , int sign );
MEMSPACE int p_ntoa ( unsigned long num , char *str , int max , int radix , int prec );
MEMSPACE int p_ftoa ( double val , char *str , int intprec , int prec , int sign );
MEMSPACE int p_etoa ( double x , char *str , int prec , int sign );
MEMSPACE void _puts_pad ( printf_t *fn , char *s , int width , int count , int left );
MEMSPACE void _printf_fn ( printf_t *fn , const char *fmt , va_list va );
void _putc_buffer_fn ( struct _printf_t *p , char ch );
MEMSPACE int vsnprintf ( char *str , size_t size , const char *format , va_list va );
MEMSPACE int snprintf ( char *str , size_t size , const char *format , ...);

// ====================================================================



#endif	// ifndef _PRINTF_H_
