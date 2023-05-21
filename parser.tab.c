/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
# include "parser.h"

FILE* logFile;

void yyerror(char *s);
int yylex();
int yyparse();

/* defining constants for data types*/
#define typeVoid 0
#define typeInteger 1
#define typeFloat 2
#define typeBoolean 3
#define typeCharchter 4
#define typeString 5

#define identifierKind 1
#define constantKind 2
#define functionKind 3

#define valueMismatch 1
#define constValueMismatch 2
#define ifCondBoolErr 3
#define whileCondBoolErr 4
#define forCondBoolErr 5
#define caseMismatch 6
#define returnMismatch 7
#define funArgMismatch 8


int getType( int i);
int getKind( int i);

int checkKind (int kind);
void setUsed(int i);

/*my functions*/
valueNode* setValueNode(int type, void* value);
void addToSymbolTable(char* name , int type, int kind, valueNode* value);
int inTable(char* name);
int inTableGlobal(char* name);
int checkType(int x , valueNode* y , int errorType);
valueNode* Operations (char operation,valueNode* par1, valueNode* par2);
valueNode* logicalOperations(char* operation, valueNode* par1, valueNode* par2);
void comparisonOperations(char* opeartion, valueNode* par1, valueNode* par2, valueNode* result);
void addOperation(valueNode* p, valueNode* val1, valueNode* val2);
void subtractOperation(valueNode* p, valueNode* val1, valueNode* val2);
void multiplyOperation(valueNode* p, valueNode* val1, valueNode* val2);
void divideOperation(valueNode* p, valueNode* val1, valueNode* val2);
void modOperation(valueNode* p, valueNode* val1, valueNode* val2);
valueNode* getIDValue(char* name);
void printSymbolTable();
void printSymbolTableCSV();
void removeCurrentScope();
void updateSymbolTable(char* name, valueNode* value);
valueNode* getIDValue(char* name);
int checkArgs(Args* args1, Args* args2);
int functionInTable(char* name, Args* args);
void addFunctionToSymbolTable(char* name, int type, int kind, Args* args);
int getActiveFunctionType();
//----------------------------------------------
struct STNode symbol_table[10000];

int scope = 0;
int idx = 0 ;
int update = 0;
int activeFunctionType = -1;

#line 143 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER_TYPE = 258,
    FLOAT_TYPE = 259,
    CHARACTER_TYPE = 260,
    STRING_TYPE = 261,
    BOOLEAN_TYPE = 262,
    IDENTIFIER = 263,
    IF = 264,
    ELSE = 265,
    DO = 266,
    WHILE = 267,
    FOR = 268,
    BREAK = 269,
    CONTINUE = 270,
    SWITCH = 271,
    CASE = 272,
    DEFAULT = 273,
    CHARACTER = 274,
    STRING = 275,
    INT = 276,
    FLOAT = 277,
    BOOLEAN = 278,
    CONSTANT = 279,
    VOID = 280,
    RETURN = 281,
    ENUM = 282,
    EQUAL = 283,
    NOT_EQUAL = 284,
    GREATER_THAN_OR_EQUAL = 285,
    LESS_THAN_OR_EQUAL = 286,
    AND = 287,
    OR = 288,
    PRINT = 289,
    IFX = 290
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 75 "parser.y"

    int integer_value;
    float float_value;
    char char_value;
    char* string_value;
    int boolean_value;
    char* identifier;
	struct valueNodes* valueNode;
	struct Args* fnArgs;

#line 242 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  70
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   339

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  53
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  38
/* YYNRULES -- Number of rules.  */
#define YYNRULES  100
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  199

#define YYUNDEFTOK  2
#define YYMAXUTOK   290


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    45,     2,     2,     2,    44,    46,     2,
      47,    48,    42,    40,    36,    41,     2,    43,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    52,    51,
      38,    37,    39,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    49,     2,    50,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   128,   128,   131,   132,   134,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   148,
     149,   152,   152,   153,   156,   163,   172,   173,   176,   184,
     191,   200,   203,   204,   207,   208,   211,   214,   215,   216,
     217,   221,   222,   223,   226,   227,   228,   229,   232,   233,
     236,   237,   238,   239,   240,   241,   242,   243,   244,   247,
     248,   249,   250,   251,   254,   255,   256,   257,   258,   262,
     263,   265,   271,   273,   274,   278,   279,   282,   283,   286,
     287,   290,   293,   294,   295,   299,   306,   313,   317,   326,
     340,   340,   341,   341,   344,   347,   348,   349,   355,   358,
     359
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INTEGER_TYPE", "FLOAT_TYPE",
  "CHARACTER_TYPE", "STRING_TYPE", "BOOLEAN_TYPE", "IDENTIFIER", "IF",
  "ELSE", "DO", "WHILE", "FOR", "BREAK", "CONTINUE", "SWITCH", "CASE",
  "DEFAULT", "CHARACTER", "STRING", "INT", "FLOAT", "BOOLEAN", "CONSTANT",
  "VOID", "RETURN", "ENUM", "EQUAL", "NOT_EQUAL", "GREATER_THAN_OR_EQUAL",
  "LESS_THAN_OR_EQUAL", "AND", "OR", "PRINT", "IFX", "','", "'='", "'<'",
  "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'!'", "'&'", "'('", "')'",
  "'{'", "'}'", "';'", "':'", "$accept", "program", "block_statements",
  "block_statement", "block", "$@1", "return_statement", "declaration",
  "variable_declaration", "enum_declaration", "enum_list", "enum_item",
  "assignment", "expression", "math_expression", "term", "factor",
  "logical_expression", "value", "data_type", "while_statement",
  "while_declaraction", "print_statement", "argument_print",
  "for_statement", "for_declaration", "do_while_statement",
  "switch_statement", "case_statement", "arguments", "argument",
  "function", "$@2", "$@3", "function_call", "argument_call",
  "if_condition", "else_statement", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,    44,    61,    60,    62,
      43,    45,    42,    47,    37,    33,    38,    40,    41,   123,
     125,    59,    58
};
# endif

#define YYPACT_NINF (-58)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     260,   -58,   -58,   -58,   -58,   -58,    -2,   -37,   213,   -32,
     -13,    12,    38,    33,   -58,   -58,   -58,   -58,   -58,   174,
      96,    19,    97,    60,    19,    19,   113,   260,   -58,    63,
      73,   -58,   -58,    74,    43,   -58,    -1,   -58,   -58,   -58,
     122,   -58,   213,    81,   -58,   213,    82,   -58,   -58,   -58,
     213,    19,    19,    19,    92,   133,   133,    19,    29,   -58,
     -58,    19,   136,   100,   101,   298,   102,    19,   -58,   270,
     -58,   -58,   -58,   -58,   -58,    19,    19,    19,    19,    19,
      19,    19,    19,   132,   132,   -58,   132,   132,   132,    59,
     -58,   -58,   -58,   -58,   -58,   -58,   139,   139,   298,   298,
     -28,   298,   104,   -58,   260,   -58,   -58,   105,   117,   106,
     108,   148,   284,   123,   -58,   154,   298,   -19,   -58,    47,
      47,   -22,   -22,    62,    80,   -22,   -22,   -58,    -1,    -1,
     -58,   -58,   -58,    19,   -58,   213,   -58,   -58,    19,   -58,
     -58,   165,   -58,    19,    19,   126,   116,    19,   174,   129,
     -34,   -58,    19,   -58,   298,   174,   -58,   -58,   298,   -58,
     124,   131,    -5,   298,   175,   -15,   -58,   195,   154,   -58,
     298,    31,   198,   198,   197,   153,   157,   171,   174,   160,
     -58,   -58,   160,   163,   166,   161,   160,   -58,    19,   -58,
     -58,   -58,   -58,   -58,   160,   -58,   298,    -5,   -58
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,    59,    60,    62,    63,    61,    49,     0,     0,     0,
       0,     0,     0,     0,    67,    68,    64,    65,    66,     0,
       0,    25,     0,     0,     0,     0,     0,     2,     3,     0,
       0,    26,    27,     0,     0,    37,    43,    47,    38,    48,
       0,    12,     0,     0,    13,     0,     0,    14,    15,    40,
       0,     0,    97,     0,    21,     0,     0,     0,     0,    20,
      19,     0,     0,     0,    49,    24,     0,     0,    50,     0,
       1,     4,    16,     5,    18,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     6,     0,     0,     0,    28,
      70,    69,    17,    76,    75,     7,     8,     9,    36,    96,
       0,     0,    38,    23,     0,    80,    79,    38,     0,     0,
       0,     0,     0,     0,    90,     0,    74,     0,    39,    57,
      58,    53,    54,    55,    56,    51,    52,    49,    41,    42,
      44,    45,    46,     0,    92,     0,    10,    11,     0,    94,
      98,     0,    71,     0,     0,    28,     0,     0,    87,    35,
       0,    32,     0,    72,    29,    87,   100,    99,    95,    22,
      38,    38,    84,    30,     0,     0,    86,     0,     0,    31,
      73,     0,     0,     0,     0,     0,     0,    88,     0,     0,
      34,    33,     0,     0,     0,     0,     0,    81,     0,    85,
      91,    93,    77,    78,     0,    83,    89,    84,    82
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -58,   -58,   119,    20,   -36,   -58,   -58,   -58,   172,   -58,
     -58,    75,   -57,   -21,   -58,   -45,    41,   -46,    57,   -14,
     -58,    13,   -58,   -58,   -58,   -58,   -58,   -58,    44,    87,
      66,   -58,   -58,   -58,   -58,   -58,   -58,   149
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    26,    27,    28,    56,   104,    29,    30,    31,    32,
     150,   151,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,   117,    44,    45,    46,    47,   176,   165,
     166,    48,   148,   155,    49,   100,    50,   136
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      65,   110,   168,    68,    69,    62,    91,   102,   138,    94,
      53,   107,   174,   175,    97,    57,   169,   152,    83,    84,
     139,   178,     1,     2,     3,     4,     5,    64,    55,   153,
      98,    99,   101,   179,    58,    51,   101,   108,   128,   129,
     112,    86,    87,    88,   111,    52,   116,    71,    14,    15,
      16,    17,    18,    19,   119,   120,   121,   122,   123,   124,
     125,   126,    90,    59,    24,    93,    25,   178,   105,   106,
      96,    75,    76,    77,    78,    79,    80,    77,    78,   182,
      61,    81,    82,    83,    84,    81,    82,    83,    84,    60,
      75,    76,    77,    78,    85,    80,   133,   160,   161,   157,
      81,    82,    83,    84,    63,    66,   134,    67,    75,    76,
      77,    78,   154,    70,    72,   183,   184,   158,    81,    82,
      83,    84,   101,   101,    73,    74,   163,   130,   131,   132,
      89,   170,    92,    95,   164,     1,     2,     3,     4,     5,
     127,   164,   103,   190,   113,     9,   191,   114,    52,   135,
     195,   115,   140,   142,    51,   156,   145,   143,   197,   144,
     147,    71,   149,   133,   164,   162,   167,   196,     1,     2,
       3,     4,     5,     6,     7,   172,     8,     9,    10,    11,
      12,    13,   173,   177,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    14,    15,    16,    17,    18,   180,    23,
       1,     2,     3,     4,     5,   186,   108,   187,   188,    54,
      24,   192,    25,   194,   193,   159,     1,     2,     3,     4,
       5,     6,     7,   141,     8,     9,    10,    11,    12,    13,
     109,   185,    14,    15,    16,    17,    18,    19,    20,    21,
      22,   198,   171,   181,   189,     0,   137,    23,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    24,     0,
      25,     0,    54,     1,     2,     3,     4,     5,     6,     7,
       0,     8,     9,    10,    11,    12,    13,     0,     0,    14,
      15,    16,    17,    18,    19,    20,    21,    22,     0,     0,
       0,     0,     0,     0,    23,     0,     0,     0,    75,    76,
      77,    78,    79,    80,     0,    24,     0,    25,    81,    82,
      83,    84,    75,    76,    77,    78,    79,    80,   118,     0,
       0,     0,    81,    82,    83,    84,    75,    76,    77,    78,
      79,    80,   146,     0,     0,     0,    81,    82,    83,    84
};

static const yytype_int16 yycheck[] =
{
      21,    58,    36,    24,    25,    19,    42,    53,    36,    45,
      47,    57,    17,    18,    50,    47,    50,    36,    40,    41,
      48,    36,     3,     4,     5,     6,     7,     8,     8,    48,
      51,    52,    53,    48,    47,    37,    57,     8,    83,    84,
      61,    42,    43,    44,    58,    47,    67,    27,    19,    20,
      21,    22,    23,    24,    75,    76,    77,    78,    79,    80,
      81,    82,    42,    51,    45,    45,    47,    36,    55,    56,
      50,    28,    29,    30,    31,    32,    33,    30,    31,    48,
      47,    38,    39,    40,    41,    38,    39,    40,    41,    51,
      28,    29,    30,    31,    51,    33,    37,   143,   144,   135,
      38,    39,    40,    41,     8,     8,    47,    47,    28,    29,
      30,    31,   133,     0,    51,   172,   173,   138,    38,    39,
      40,    41,   143,   144,    51,    51,   147,    86,    87,    88,
       8,   152,    51,    51,   148,     3,     4,     5,     6,     7,
       8,   155,    50,   179,     8,    12,   182,    47,    47,    10,
     186,    49,    48,    48,    37,   135,     8,    51,   194,    51,
      37,   141,     8,    37,   178,    49,    37,   188,     3,     4,
       5,     6,     7,     8,     9,    51,    11,    12,    13,    14,
      15,    16,    51,     8,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    19,    20,    21,    22,    23,     3,    34,
       3,     4,     5,     6,     7,    52,     8,    50,    37,    49,
      45,    48,    47,    52,    48,    50,     3,     4,     5,     6,
       7,     8,     9,   104,    11,    12,    13,    14,    15,    16,
      58,   174,    19,    20,    21,    22,    23,    24,    25,    26,
      27,   197,   155,   168,   178,    -1,    97,    34,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    -1,
      47,    -1,    49,     3,     4,     5,     6,     7,     8,     9,
      -1,    11,    12,    13,    14,    15,    16,    -1,    -1,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    -1,    -1,
      -1,    -1,    -1,    -1,    34,    -1,    -1,    -1,    28,    29,
      30,    31,    32,    33,    -1,    45,    -1,    47,    38,    39,
      40,    41,    28,    29,    30,    31,    32,    33,    48,    -1,
      -1,    -1,    38,    39,    40,    41,    28,    29,    30,    31,
      32,    33,    48,    -1,    -1,    -1,    38,    39,    40,    41
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,     9,    11,    12,
      13,    14,    15,    16,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    34,    45,    47,    54,    55,    56,    59,
      60,    61,    62,    65,    66,    67,    68,    69,    70,    71,
      72,    73,    74,    75,    77,    78,    79,    80,    84,    87,
      89,    37,    47,    47,    49,    56,    57,    47,    47,    51,
      51,    47,    72,     8,     8,    66,     8,    47,    66,    66,
       0,    56,    51,    51,    51,    28,    29,    30,    31,    32,
      33,    38,    39,    40,    41,    51,    42,    43,    44,     8,
      56,    57,    51,    56,    57,    51,    56,    57,    66,    66,
      88,    66,    70,    50,    58,    74,    74,    70,     8,    61,
      65,    72,    66,     8,    47,    49,    66,    76,    48,    66,
      66,    66,    66,    66,    66,    66,    66,     8,    68,    68,
      69,    69,    69,    37,    47,    10,    90,    90,    36,    48,
      48,    55,    48,    51,    51,     8,    48,    37,    85,     8,
      63,    64,    36,    48,    66,    86,    56,    57,    66,    50,
      70,    70,    49,    66,    72,    82,    83,    37,    36,    50,
      66,    82,    51,    51,    17,    18,    81,     8,    36,    48,
       3,    64,    48,    65,    65,    71,    52,    50,    37,    83,
      57,    57,    48,    48,    52,    57,    66,    57,    81
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    53,    54,    55,    55,    56,    56,    56,    56,    56,
      56,    56,    56,    56,    56,    56,    56,    56,    56,    56,
      56,    58,    57,    57,    59,    59,    60,    60,    61,    61,
      61,    62,    63,    63,    64,    64,    65,    66,    66,    66,
      66,    67,    67,    67,    68,    68,    68,    68,    69,    69,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    71,
      71,    71,    71,    71,    72,    72,    72,    72,    72,    73,
      73,    74,    75,    76,    76,    77,    77,    78,    78,    79,
      79,    80,    81,    81,    81,    82,    82,    82,    83,    83,
      85,    84,    86,    84,    87,    88,    88,    88,    89,    90,
      90
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     2,     2,     2,     2,     2,     2,
       3,     3,     1,     1,     1,     1,     2,     2,     2,     2,
       2,     0,     4,     2,     2,     1,     1,     1,     2,     4,
       5,     5,     1,     3,     3,     1,     3,     1,     1,     3,
       1,     3,     3,     1,     3,     3,     3,     1,     1,     1,
       2,     3,     3,     3,     3,     3,     3,     3,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     2,
       2,     4,     4,     3,     1,     2,     2,     8,     8,     3,
       3,     7,     5,     3,     0,     3,     1,     0,     2,     4,
       0,     7,     0,     7,     4,     3,     1,     0,     4,     2,
       2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 21:
#line 152 "parser.y"
            {scope++;}
#line 1587 "parser.tab.c"
    break;

  case 22:
#line 152 "parser.y"
                                            {removeCurrentScope(); scope--;}
#line 1593 "parser.tab.c"
    break;

  case 24:
#line 157 "parser.y"
        {
		if(activeFunctionType == -1)
			printf("error: return statement not in a function\n");
		else
			checkType(activeFunctionType, (yyvsp[0].valueNode), returnMismatch);
	}
#line 1604 "parser.tab.c"
    break;

  case 25:
#line 164 "parser.y"
        {
		if(activeFunctionType == -1)
			printf("error: return statement not in a function\n");
		else if(activeFunctionType != typeVoid)
			printf("error: return type mismatch\n");
	}
#line 1615 "parser.tab.c"
    break;

  case 28:
#line 177 "parser.y"
        {
		if(inTable((char*)(yyvsp[0].identifier)) != -1)
			// error that the variable has been declared before
			printf("error: Variable %s has been declared before\n", (char*)(yyvsp[0].identifier));
		else
			addToSymbolTable((char*)((yyvsp[0].identifier)),(yyvsp[-1].integer_value),identifierKind, NULL);
	}
#line 1627 "parser.tab.c"
    break;

  case 29:
#line 185 "parser.y"
        {
		if(inTable((char*)(yyvsp[-2].identifier)) != -1)
			printf("error: Variable %s has been declared before\n", (char*)(yyvsp[-2].identifier));
		else if ((yyvsp[0].valueNode) != NULL && checkType((yyvsp[-3].integer_value),(yyvsp[0].valueNode),valueMismatch) != -1); 
			addToSymbolTable((char*)((yyvsp[-2].identifier)),(yyvsp[-3].integer_value),identifierKind, (yyvsp[0].valueNode));
	}
#line 1638 "parser.tab.c"
    break;

  case 30:
#line 192 "parser.y"
        {
		if(inTable((char*)(yyvsp[-2].identifier)) != -1)
			printf("error: Constant %s has been declared before\n", (char*)(yyvsp[-2].identifier));
		else if ((yyvsp[0].valueNode) != NULL && checkType((yyvsp[-3].integer_value),(yyvsp[0].valueNode),valueMismatch) != -1); 
			addToSymbolTable((char*)((yyvsp[-2].identifier)),(yyvsp[-3].integer_value),constantKind, (yyvsp[0].valueNode));
	}
#line 1649 "parser.tab.c"
    break;

  case 36:
#line 211 "parser.y"
                                        {updateSymbolTable((yyvsp[-2].identifier),(yyvsp[0].valueNode));}
#line 1655 "parser.tab.c"
    break;

  case 37:
#line 214 "parser.y"
                             { (yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1661 "parser.tab.c"
    break;

  case 38:
#line 215 "parser.y"
                              { (yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1667 "parser.tab.c"
    break;

  case 39:
#line 216 "parser.y"
                             { (yyval.valueNode) = (yyvsp[-1].valueNode);}
#line 1673 "parser.tab.c"
    break;

  case 40:
#line 217 "parser.y"
                             { (yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1679 "parser.tab.c"
    break;

  case 41:
#line 221 "parser.y"
                                      {(yyval.valueNode) = Operations('+', (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1685 "parser.tab.c"
    break;

  case 42:
#line 222 "parser.y"
                                              {(yyval.valueNode) = Operations('-', (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1691 "parser.tab.c"
    break;

  case 43:
#line 223 "parser.y"
                                          {(yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1697 "parser.tab.c"
    break;

  case 44:
#line 226 "parser.y"
                            {(yyval.valueNode) = Operations('*', (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1703 "parser.tab.c"
    break;

  case 45:
#line 227 "parser.y"
                            {(yyval.valueNode) = Operations('/', (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1709 "parser.tab.c"
    break;

  case 46:
#line 228 "parser.y"
                            {(yyval.valueNode) = Operations('%', (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1715 "parser.tab.c"
    break;

  case 47:
#line 229 "parser.y"
                            {(yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1721 "parser.tab.c"
    break;

  case 48:
#line 232 "parser.y"
                            {(yyval.valueNode) = (yyvsp[0].valueNode);}
#line 1727 "parser.tab.c"
    break;

  case 49:
#line 233 "parser.y"
                            {(yyval.valueNode) = getIDValue((yyvsp[0].identifier));}
#line 1733 "parser.tab.c"
    break;

  case 50:
#line 236 "parser.y"
                                      { (yyval.valueNode) = logicalOperations("!", (yyvsp[0].valueNode), NULL); }
#line 1739 "parser.tab.c"
    break;

  case 51:
#line 237 "parser.y"
                                          { (yyval.valueNode) = logicalOperations("<", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1745 "parser.tab.c"
    break;

  case 52:
#line 238 "parser.y"
                                          { (yyval.valueNode) = logicalOperations(">", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1751 "parser.tab.c"
    break;

  case 53:
#line 239 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations(">=" , (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1757 "parser.tab.c"
    break;

  case 54:
#line 240 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations("<=", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1763 "parser.tab.c"
    break;

  case 55:
#line 241 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations("&&", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1769 "parser.tab.c"
    break;

  case 56:
#line 242 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations("||", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1775 "parser.tab.c"
    break;

  case 57:
#line 243 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations("==", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1781 "parser.tab.c"
    break;

  case 58:
#line 244 "parser.y"
                                                          { (yyval.valueNode) = logicalOperations("!=", (yyvsp[-2].valueNode), (yyvsp[0].valueNode)); }
#line 1787 "parser.tab.c"
    break;

  case 59:
#line 247 "parser.y"
                     { (yyval.valueNode) = setValueNode(typeInteger, &(yyvsp[0].integer_value)); }
#line 1793 "parser.tab.c"
    break;

  case 60:
#line 248 "parser.y"
                         { (yyval.valueNode) = setValueNode(typeFloat, &(yyvsp[0].float_value)); }
#line 1799 "parser.tab.c"
    break;

  case 61:
#line 249 "parser.y"
                         { (yyval.valueNode) = setValueNode(typeFloat, &(yyvsp[0].boolean_value)); }
#line 1805 "parser.tab.c"
    break;

  case 62:
#line 250 "parser.y"
                         { (yyval.valueNode) = setValueNode(typeCharchter, &(yyvsp[0].char_value)); }
#line 1811 "parser.tab.c"
    break;

  case 63:
#line 251 "parser.y"
                         { (yyval.valueNode) = setValueNode(typeString, &(yyvsp[0].string_value)); }
#line 1817 "parser.tab.c"
    break;

  case 64:
#line 254 "parser.y"
               { (yyval.integer_value) = typeInteger; }
#line 1823 "parser.tab.c"
    break;

  case 65:
#line 255 "parser.y"
                   { (yyval.integer_value) = typeFloat; }
#line 1829 "parser.tab.c"
    break;

  case 66:
#line 256 "parser.y"
                   { (yyval.integer_value) = typeBoolean; }
#line 1835 "parser.tab.c"
    break;

  case 67:
#line 257 "parser.y"
                    { (yyval.integer_value) = typeCharchter; }
#line 1841 "parser.tab.c"
    break;

  case 68:
#line 258 "parser.y"
                    { (yyval.integer_value) = typeString; }
#line 1847 "parser.tab.c"
    break;

  case 85:
#line 300 "parser.y"
        {
		Args* args = (Args*)(yyvsp[-2].fnArgs);
		args->types[args->nargs] = (yyvsp[0].integer_value);
		args->nargs++;
		(yyval.fnArgs) = args;
	}
#line 1858 "parser.tab.c"
    break;

  case 86:
#line 307 "parser.y"
        {
	 	Args* args = (Args*)malloc(sizeof(Args));
		args->types[0] = (yyvsp[0].integer_value);
		args->nargs = 1;
		(yyval.fnArgs) = args;
	}
#line 1869 "parser.tab.c"
    break;

  case 87:
#line 313 "parser.y"
                 {Args* args = (Args*)malloc(sizeof(Args)); args->nargs = 0; (yyval.fnArgs) = args;}
#line 1875 "parser.tab.c"
    break;

  case 88:
#line 318 "parser.y"
        {
		if(inTable((char*)(yyvsp[0].identifier)) != -1)
			printf("error: Variable %s has been declared before\n", (char*)(yyvsp[0].identifier));
		else {
			addToSymbolTable((char*)(yyvsp[0].identifier),(yyvsp[-1].integer_value),functionKind, NULL);
			(yyval.integer_value) = (yyvsp[-1].integer_value);
		}
	}
#line 1888 "parser.tab.c"
    break;

  case 89:
#line 327 "parser.y"
        {	
		int check = checkType((yyvsp[-3].integer_value),(yyvsp[0].valueNode),funArgMismatch);
		if(check != -1) {
			if(inTable((char*)(yyvsp[-2].identifier)) != -1)
				printf("error: Variable %s has been declared before\n", (char*)(yyvsp[-2].identifier));
			else if ((yyvsp[0].valueNode) != NULL && checkType((yyvsp[-3].integer_value),(yyvsp[0].valueNode),valueMismatch) != -1) {
				addToSymbolTable((char*)(yyvsp[-2].identifier),(yyvsp[-3].integer_value),functionKind, (yyvsp[0].valueNode));
				(yyval.integer_value) = (yyvsp[-3].integer_value);
			}
		}
	}
#line 1904 "parser.tab.c"
    break;

  case 90:
#line 340 "parser.y"
                                {activeFunctionType = typeVoid;}
#line 1910 "parser.tab.c"
    break;

  case 91:
#line 340 "parser.y"
                                                                                      {activeFunctionType = -1; addFunctionToSymbolTable((yyvsp[-5].identifier),typeVoid,functionKind, (yyvsp[-2].fnArgs));}
#line 1916 "parser.tab.c"
    break;

  case 92:
#line 341 "parser.y"
                                     {activeFunctionType = (yyvsp[-2].integer_value);}
#line 1922 "parser.tab.c"
    break;

  case 93:
#line 341 "parser.y"
                                                                                     {activeFunctionType = -1; addFunctionToSymbolTable((yyvsp[-5].identifier),(yyvsp[-6].integer_value),functionKind, (yyvsp[-2].fnArgs));}
#line 1928 "parser.tab.c"
    break;


#line 1932 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 362 "parser.y"


//-------------------------------------------------------------------------------------------------
void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}


//--------------------------------------------------
/* My functions*/
valueNode* setValueNode(int type, void* value){
	valueNode* p = (valueNode*)malloc(sizeof(valueNode));
	p->type = type;
	//p->kind = constantKind;
	if (type == typeInteger)
		p->integer = *((int *)value);
	else if (type == typeFloat)
		p->floatNumber = *((float *)value);
	else if (type == typeBoolean)
		p->boolean = *((int *)value);
	else if (type == typeCharchter)
		p->character = *((char *)value);
	else
		p->name = (char*)value;
	return p;
}


// this function checks that all the args are of the same type as another args types
// 0 means that the 2 args are not the same
// 1 means that the 2 args are the same
int checkArgs(Args* args1, Args* args2){
	if (args1->nargs != args2->nargs) {
		for(int i=0; i<args1->nargs; i++){
			if (args1->types[i] != args2->types[i])
				return 0;
		}
		return 1;
	}
	else
		return 0;

}

int functionInTable(char* name, Args* args){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0 && symbol_table[i].kind == functionKind && checkArgs(args, symbol_table[i].args) == 1) {
			return i;  
		}
		else if(!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0 && (symbol_table[i].kind == identifierKind || symbol_table[i].kind == constantKind)) {
			return i;
		}
	return -1;
}

void addFunctionToSymbolTable(char* name, int type, int kind, Args* args){
	if(scope != 0){
		printf("Error: function %s  must be global\n", name);
	}
	else {
		if (functionInTable(name, args) != -1){
			printf("Error: function %s is already defined\n", name);
		}
		else{
			struct STNode p;
			p.isUsed = 1;
			p.type = type;
			p.kind = kind;
			p.name = name;
			p.scope = scope;
			p.args = args;
			symbol_table[idx++] = p;
			// print the symbol table as CSV
			printSymbolTableCSV();
		}
	}

}

void addToSymbolTable(char* name , int type, int kind, valueNode* value) { 
	struct STNode p; 
	p.isUsed = 1;
	p.type = type;
	p.name = name;
	if(kind == functionKind) {
		p.scope = 1;
		p.kind = identifierKind;
	}
	else {
		p.scope = scope;
		p.kind = kind;
	}
	if(value == NULL) {
		valueNode* v = (valueNode*)malloc(sizeof(valueNode));
		v->type = type;
		v->kind = kind;
		p.value = v;
	}
	else
		p.value = value;
	symbol_table[idx++] = p;

	// print the symbol table as CSV
	printSymbolTableCSV();
} 


int inTable(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == scope  && symbol_table[i].isUsed == 1)
			return i;  
	return -1;
} 

int inTableGlobal(char* name){
	for (int i =0;i < idx;i++)
		if (!strcmp(name,symbol_table[i].name) && symbol_table[i].scope == 0)
			return i;  
	return -1;
}

int checkType(int x , valueNode* y , int errorType){
	if (y != NULL && x != y->type){
		switch (errorType){
			case valueMismatch:
				yyerror("variable/constant mismatches with the assigned value "); 
				break; 
			case ifCondBoolErr:
				yyerror("if condition  must be of type boolean ");  
				break;
			case whileCondBoolErr:
				yyerror("while condition must be of type boolean ");  
				break;
			case forCondBoolErr:
				yyerror("for condition must be of type boolean ");  
				break;
			case caseMismatch:
				yyerror("case variable type must be same as switch variable type ");  
				break;
			case returnMismatch:
				yyerror("return type must be the same as function type ");  
				break;
			case funArgMismatch:
				yyerror("function argument value must be the same as function argument type "); 
				break;
		}
		return -1;
	}
	return x;
}

void addOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: 
		case typeFloat:
		case typeBoolean:
		case typeCharchter:
			break;
		case typeString: {
			// error string does not support addition
			printf("string does not support addition");
			break;
		}
	}
}

void subOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: 
		case typeFloat: 
		case typeBoolean: 
		case typeCharchter:
			break;
		case typeString: {
			// error string does not support subtraction
			printf("string does not support subtraction");
			break;
		}
	}
}

void multiplyOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger:
		case typeFloat:
		case typeBoolean:
		case typeCharchter:
			break;
		case typeString: {
			// error string does not support subtraction
			printf("string does not support multiplication");
			break;
		}
	}
}

void modeOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			printf("Float values do not support mode operation");
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("Boolean values do not support mode operation");
			break;
		}
		case typeCharchter: 
		  	break;
		case typeString: {
			// error string does not support subtraction
			printf("String values do not support mode operation");
			break;
		}
	}
}

void divideOperation(valueNode* p, valueNode* val1, valueNode* val2) {
	switch(p->type) {
		case typeInteger: {
			if (val2->integer == 0)
				yyerror("division by zero"); 
			break;
		}
		case typeFloat: {
			if (val2->floatNumber == 0.0)
				yyerror("division by zero"); 
			break;
		}
		case typeBoolean: {
			printf("boolean does not support divide operation");
			break;
		}
		case typeCharchter: {
			printf("character does not support divide operation");
			break;
		}
		case typeString: {
			// error string does not support subtraction
			printf("string does not support divide operation");
			break;
		}
	}
}


// TODO: Don't forget to generate Quadruples for each operation
valueNode* Operations (char operation,valueNode* par1, valueNode* par2) {
	int type1 = par1->type;
	int type2 = par2->type;
	// check if the two types are the same
	if (checkType(type1, par2, valueMismatch) == type1){
		valueNode* p = (valueNode*)malloc(sizeof(valueNode));
		p->type = type1;
		switch(operation) {
			case '+': {
				addOperation(p, par1, par2);
				break;
			}
			case '-': {
				subOperation(p, par1, par2);
				break;
			}
			case '*': {
				multiplyOperation(p, par1, par2);
				break;
			}
			case '%': {
				modeOperation(p, par1, par2);
				break;
			}
			case '/': {
				divideOperation(p, par1, par2);
				break;
			}
			default: {
				printf("operation not supported");
				break;
			}
		}
		return p;
	}
	return NULL;
	
}

// TODO: Don't forget to generate Quadruples for each operation
void comparisonOperations(char* operation, valueNode* par1, valueNode* par2, valueNode* result) {

	int type1 = par1->type;
	switch(type1) {
		case typeInteger: 
		case typeFloat: 
		case typeBoolean: 
		case typeCharchter:
			// generate Quadruples
			break;
		case typeString: {
			if(strcmp(operation, "==") == 0) {
				//result->boolean = (strcmp(val1, val2) == 0);
				printf("Error: cannot compare strings with ==\n");
			}
			else if(strcmp(operation, "!=") == 0) {
				//result->boolean = (strcmp(val1, val2) != 0);
				printf("Error: cannot compare strings with !=\n");
			}
			else if(strcmp(operation, ">") == 0) {
				printf("Error: cannot compare strings with >\n");
			}
			else if(strcmp(operation, "<") == 0) {
				printf("Error: cannot compare strings with <\n");
			}
			else if(strcmp(operation, ">=") == 0) {
				printf("Error: cannot compare strings with >=\n");
			}
			else if(strcmp(operation, "<=") == 0) {
				printf("Error: cannot compare strings with <=\n");
			}
		}
	}
}



valueNode* logicalOperations(char* operation, valueNode* par1, valueNode* par2) {
	int type1 = par1->type;
	int type2 = par2->type;
	// check if the two types are the same
	if (checkType(type1, par2, valueMismatch) == type1){
		valueNode* p = (valueNode*)malloc(sizeof(valueNode));
		p->type = typeBoolean;
		if(strcmp(operation, "&&") == 0) {
			//p->boolean = par1->boolean && par2->boolean;
		}
		else if(strcmp(operation, "||") == 0) {
			//p->boolean = par1->boolean || par2->boolean;
		}
		else if(strcmp(operation, "!") == 0) {
			//p->boolean = !par1->boolean;
		}
		else {
			comparisonOperations(operation, par1, par2, p);
		}
		return p;
	}
	return NULL;
}

valueNode* getIDValue(char* name) {
	// check that the variable is in the symbol table
	int index = inTable(name);
	if (index == -1) {
		printf("variable %s not declared in this scope\n", name);
		return NULL;
	}
	// check that the variable is initialized
	if (symbol_table[index].isUsed == 0) {
		yyerror("variable not initialized");
		return NULL;
	}
	// return the value of the variable
	return symbol_table[index].value;
}

int getActiveFunctionType() {
	for (int i = 0; i < idx; i++) {
		if (symbol_table[i].isUsed == 1 && symbol_table[i].kind == functionKind) {
			return symbol_table[i].type;
		}
	}
	return -1;
}

void updateSymbolTable(char* name, valueNode* value) {
	// check that the variable is in the symbol table in the global scope (scope = 0)
	int index = inTable(name);
	if (index == -1) {
		// here the variable is not in the current scope but it may be in the global scope
		index = inTableGlobal(name);
		if (index == -1) {
			printf("variable %s not declared", name);
			return;
		}
	}

	// update the value of the variable
	symbol_table[index].value = value;
	
	// print the symbol table as CSV
	printSymbolTableCSV();	

}

// this function removes all variables with current scope from the symbol table using deallocation 
void removeCurrentScope() {
	int i;
	for (i = 0; i < idx; i++) {
		if (symbol_table[i].scope == scope) {
			symbol_table[i].isUsed = 0;
			symbol_table[i].value = NULL;
		}
	}
}


// this function prints the symbol table in the log file as a comma separated values
void printSymbolTableCSV() {
	// Open the log file
	logFile = fopen("symbol_table.log", "a");
	if (logFile == NULL) {
		fprintf(stderr, "Error opening log file.\n");
		exit(1);
	}
	//update++;
	//fprintf(logFile, "%d,", update);
	// print the fields names
	fprintf(logFile, "name, scope, type, kind\n");
	int i;
	for (i = 0; i < idx; i++) {
		// print each entry in the symbol table as a comma separated values regardelss of the value
		fprintf(logFile, "%s, %d, %d, %d\n", symbol_table[i].name, symbol_table[i].scope, symbol_table[i].type, symbol_table[i].kind);
	}
	// print a separator line
	fprintf(logFile, "==================================================\n");

	// Close the log file
	fclose(logFile);
}
