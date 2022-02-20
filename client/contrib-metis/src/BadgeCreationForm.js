import React, {Component} from 'react';

class MeritSubmitForm extends Component {
    constructor(props) {
        super(props);

        this.initialState = {
            name: '',
            symbol: ''
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
        const { name, symbol } = this.state;

        return (
            <form onSubmit={this.onFormSubmit}>
                <label for="name">Name</label>
                <input
                    type="text"
                    name="name"
                    id="name"
                    value={name}
                    onChange={this.handleChange} />
                <label for="symbol">Message</label>
                <input
                    type="text"
                    name="symbol"
                    id="symbol"
                    value={symbol}
                    onChange={this.handleChange} />
            </form>
        );
    }
}

export default MeritSubmitForm;
