import React, {Component} from 'react';

class MeritSubmitForm extends Component {
    constructor(props) {
        super(props);

        this.initialState = {
            name: '',
            message: ''
        };

        this.state = this.initialState;
    }

    handleChange = event => {
        const { name, value } = event.target;

        this.setState({
            [name] : value
        });
    }

    onFormSubmit = (event) => {
        event.preventDefault();

        this.props.handleSubmit(this.state);
        this.setState(this.initialState);
    }

    render() {
        const { name, message } = this.state;

        return (


<div className="MeritSubmitForm">
<div className="min-h-screen bg-purple-400 flex justify-center items-center">
	<div className="py-12 px-12 bg-white rounded-2xl shadow-xl z-20">
		<div>
			<h1 className="text-3xl font-bold text-center mb-4 cursor-pointer">Submit a Contribution Statement</h1>
			<p className="w-80 text-center text-sm mb-8 font-semibold text-gray-700 tracking-wide cursor-pointer">You've contributed to the DAO, great work, now submit the contribution for attestation by other members of the DAO</p>
		</div>

		<div className="space-y-4">
      <form onSubmit={this.onFormSubmit}>
			<input type="text" name="name" id="name" placeholder="Name" className="block text-sm py-3 px-4 rounded-lg w-full border outline-none" value={name} onChange={this.handleChange}/>
			<input type="text" name="message" id="message" placeholder="Contribution Message" className="block text-sm py-3 px-4 rounded-lg w-full border outline-none" value={message} onChange={this.handleChange}/>
      <button className="py-3 w-64 text-xl text-white bg-purple-400 rounded-2xl" type="submit">Submit Contribution</button>
      </form>
    </div>
			<div className="text-center mt-6">

				<p className="mt-4 text-sm">Not signed in? <span className="underline cursor-pointer">Connect Wallet</span>
				</p>
			</div>
		</div>
	</div>
</div>


        );
    }
}

export default MeritSubmitForm;
