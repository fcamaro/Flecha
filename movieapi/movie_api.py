from flask import Flask, request
from movies import MovieAPI

app = Flask(__name__)

def sanitize(param, type):
    # Perform sanitization on the parameter
    if not (param is None) :
        sanitized_param = param
    else:
        if type=="int":
            sanitized_param = "0"
        else :
            sanitized_param =""   
    return sanitized_param

@app.route("/movies", methods=["GET"])
def movies_search():
    return MovieAPI.movies_search(sanitize(request.args.get("id"),"int"),
                                      sanitize(request.args.get("title"),"str"),
                                      sanitize(request.args.get("year"),"int"),
                                      sanitize(request.args.get("genre"),"genre"),
                                      sanitize(request.args.get("cast"),"cast")
                                      )

if __name__ == "__main__":
    app.run(debug=True)
