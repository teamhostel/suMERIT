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
            <form onSubmit={this.onFormSubmit}>
                <label for="name">Name</label>
                <input
                    type="text"
                    name="name"
                    id="name"
                    value={name}
                    onChange={this.handleChange} />
                <label for="message">Message</label>
                <input
                    type="text"
                    name="message"
                    id="message"
                    value={message}
                    onChange={this.handleChange} />
                <button type="submit">
                    Submit
                </button>
            </form>
        );
    }
}

export default MeritSubmitForm;
