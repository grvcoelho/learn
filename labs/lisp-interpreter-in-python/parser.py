import math
import operator as op

Symbol = str
Number = (int, float)
Atom   = (Symbol, Number)
List   = list
Exp    = (Atom, List)
Env    = dict

def standard_env() -> Env:
    "An environment with some Scheme standard procedures"
    env = Env()
    env.update(vars(math)) # sin, cos, sqrt, pi, ...
    env.update({
        '+': op.add,
        '-': op.sub,
        '*': op.mul,
        '/': op.truediv,
        '>': op.gt,
        '<': op.lt,
        '>=': op.ge,
        '<=': op.le,
        'abs': abs,
        'append': op.add,
        'apply': lambda proc, args: proc(*args),
        'begin': lambda *x: x[-1],
        'car': lambda x: x[0],
        'cdr': lambda x: x[1:],
        'cons': lambda x,y: [x] + y,
        'eq?': op.is_,
        'expt': pow,
        'equal?': op.eq,
        'length': len,
        'list': lambda *x: List(x),
        'list?': lambda x: isinstance(x, List),
        'map': map,
        'max': max,
        'min': min,
        'not': op.not_,
        'null?': lambda x: x == [],
        'number?': lambda x: instance(x, Number),
        'print': print,
        'procedure?': callable,
        'round': round,
        'symbol?': lambda x: isinstance(x, Symbol)
    })
    return env

def tokenize(chars: str) -> List:
    "Convert a string of characters into a list of tokens"
    return chars.replace('(', ' ( ').replace(')', ' ) ').split()

def parse(program: str) -> Exp:
    "Read a Scheme expression from a string"
    tokens = tokenize(program)
    return read_from_tokens(tokens)

def read_from_tokens(tokens: List) -> Exp:
    "Read an expression from a sequence of tokens"

    if len (tokens) == 0:
        raise SyntaxError('unexpected EOF')

    token = tokens.pop(0)

    if token == '(':
        L = []
        while tokens[0] != ')':
            L.append(read_from_tokens(tokens))
        tokens.pop(0) # pop off ')'
        return L
    elif token == ')':
        raise SyntaxError('unexpected )')
    else:
        return atom(token)

def atom(token: str) -> Atom:
    "Numbers become numbers; every other token is a symbol"
    try: return int(token)
    except ValueError:
        try: return float(token)
        except ValueError:
            return Symbol(token)

global_env = standard_env()

def eval(x: Exp, env=global_env) -> Exp:
    "Evaluate an expression in an environment"

    # Variable reference
    if isinstance(x, Symbol):
        return env[x]
    # Constant number
    elif isinstance(x, Number):
        return x
    # Conditional
    elif x[0] == 'if':
        (_, test, conseq, alt) = x
        exp = (conseq if eval(test, env) else alt)
        return eval(exp, env)
    # Define
    elif x[0] == 'define':
        (_, symbol, exp) = x
        env[symbol] = eval(exp, env)
    # Procedure Call
    else:
        proc = eval(x[0], env)
        args = [eval(arg, env) for arg in x[1:]]
        return proc(*args)

def repl(prompt='lis.py> '):
    "A prompt read-eval-print loop"
    while True:
        val = eval(parse(input(prompt)))
        if val is not None:
            print(schemestr(val))

def schemestr(exp):
    "Convert a Python object back into a Scheme-readable string"
    if isinstance(exp, List):
        return '(', + ' '.join(map(schemestr, exp)) + ')'
    else:
        return str(exp)

program = "(begin (define r 10) (* pi (* r r)))"

result = eval(parse(program))

repl()
