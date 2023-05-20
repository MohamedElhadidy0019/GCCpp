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
    union
    {
        int integer;
        float floatNumber;
        int boolean;
        char character;
        char *name;
    };
} valueNode;



struct STNode
{
    int type;
    int kind;
    char *name;
    int scope;
    int isUsed;
    valueNode *value;
};