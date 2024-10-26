import logging
from flask import Flask, render_template, request, redirect, url_for, session

# Setup logging
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Sample products
products = [
    {'id': '1', 'name': 'Producto 1', 'price': 10, 'description': 'Descripción del producto 1'},
    {'id': '2', 'name': 'Producto 2', 'price': 20, 'description': 'Descripción del producto 2'},
    {'id': '3', 'name': 'Producto 3', 'price': 30, 'description': 'Descripción del producto 3'}
]

# Initialize the cart with all products set to 0 quantity without using a loop
def initialize_cart():
    cart = {
        products[0]['id']: 0,  # Initialize for Product 1
        products[1]['id']: 0,  # Initialize for Product 2
        products[2]['id']: 0   # Initialize for Product 3
    }
    return cart

@app.route('/')
def index():
    return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == 'admin' and password == 'password':
            session['username'] = username
            return redirect(url_for('home'))
        else:
            return render_template('login.html', error='Credenciales inválidas')
    return render_template('login.html')

@app.route('/home')
def home():
    return render_template('home.html', products=products)

@app.route('/add_to_cart/<product_id>')
def add_to_cart(product_id):
    # Initialize the cart if it doesn't exist
    if 'cart' not in session or not isinstance(session['cart'], dict):
        session['cart'] = initialize_cart()  # Ensure cart is a dictionary

    cart = session['cart']
    
    # Increment quantity in the cart
    if product_id in cart:
        cart[product_id] += 1  # Increment quantity
    else:
        cart[product_id] = 1  # Set to 1 if not present

    session['cart'] = cart
    return redirect(url_for('home'))

@app.route('/cart', methods=['GET', 'POST'])
def cart():
    # Initialize the cart if it doesn't exist
    if 'cart' not in session or not isinstance(session['cart'], dict):
        session['cart'] = initialize_cart()  # Ensure cart is a dictionary

    cart = session['cart']

    if request.method == 'POST':
        product_id = request.form['product_id']
        action = request.form['action']
        quantity_field = f'quantity_{product_id}'
        # Update or remove item from cart
        if product_id in cart:
            if action == 'update':
                new_quantity = int(request.form[quantity_field])
                cart[product_id] = max(new_quantity, 0)  # Ensure quantity is not negative
            elif action == 'remove':
                cart[product_id] = 0  # Set quantity to 0 instead of removing the entry
    
    # Prepare cart items for rendering
    cart_items = []
    total_price = 0
    for pid, quantity in cart.items():
        if quantity > 0:  # Only display products with a quantity greater than 0
            product = None
            for p in products:
                if p['id'] == pid:
                    product = p
                    break
            if product:
                total = product['price'] * quantity
                cart_items.append({**product, 'quantity': quantity, 'total': total})
                total_price += total
    
    session['cart'] = cart
    return render_template('cart.html', cart_items=cart_items, total_price=total_price)

@app.route('/reset_cart')
def reset_cart():
    session['cart'] = initialize_cart()
    return redirect(url_for('cart'))

if __name__ == '__main__':
    app.run(debug=True)
