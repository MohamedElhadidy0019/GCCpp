/* operators */
typedef struct
{
    int oper;                  /* operator */
    int nops;                  /* number of operands */
    struct nodeTypeTag *op[2]; /* operands (expandable) */
} oprNodeType;

typedef struct nodeTypeTag
{
    int type;
    int kind;
    char *name;
    int scope;
    int isUsed;
    void *value;
    union
    {
        oprNodeType opr;
    };
} nodeType;

typedef struct valueNodes
{
    int type;
    int used;
    union
    {
        int integer;
        float floatNumber;
        int boolean;
        char character;
        char *name;
    };
} valueNode;
