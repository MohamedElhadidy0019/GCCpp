/* operators */
typedef struct
{
    int oper;                  /* operator */
    int nops;                  /* number of operands */
    struct nodeTypeTag *op[2]; /* operands (expandable) */
} oprNodeType;

typedef struct valueNodes
{
    int type;
    int kind;
    char* enumName;
    union
    {
        int integer;
        float floatNumber;
        int boolean;
        char character;
        char *name;
    };
} valueNode;

typedef struct EnumNode {
    char* name;
    int value;
} EnumNode;

typedef struct EnumList {
    char* names[10];
    int values[10];
    int nvals;
} EnumList;

typedef struct Args {
    int types[10];
    int nargs; 
} Args;
struct FnCall {
    valueNode* args[10];
    int nargs;
};

struct STNode
{
    int type;
    int kind;
    char *name;
    int scope;
    int isUsed;
    valueNode *value;
    struct Args *args;
};