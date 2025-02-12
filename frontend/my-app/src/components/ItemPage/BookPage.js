import React, { Component } from 'react';
import axios from "axios";
import Star from '../Star'

import {
	MDBMask,
	MDBView,
	MDBContainer,
	MDBRow,
	MDBCol,
	MDBCard,
	MDBCardBody,
	MDBCardImage,
	MDBCardTitle,
	MDBCardText
} from "mdbreact";

const orangeText = {
	color: "rgb(205,93,0)"
}

class BookPage extends Component {
	constructor() {
		super();
			this.state = {
				validBook: false,
			};
	}
	componentDidMount() {
		const bookId = this.props.match.params.isbn
		axios.get(`http://localhost:5050/api/b/books/details/${bookId}`)
		.then (response => {
			if(!response.data)
			{
				this.props.history.push('/error')
			}
			else	
			{
				this.setState(response.data);
				this.setState({validBook: true});
			}
		})
		.catch(err => {
			console.log(err);
		})
	}

	convertCase(txt) {
		 return txt.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
	}

	render() {
		if (!this.state.validBook)
			return ("")
		return (
			<MDBView>
				<div className = "d-flex justify-content-center"
				>
					<MDBCard style = {{
						width: "60rem",
					}} className="mt-5">
						<MDBRow style={{height:"100%"}} className="mx-1">
							<MDBCol size="5" style = {{
								backgroundImage: `url(${this.state.poster})`,
								backgroundPosition: "center",
								backgroundRepeat: "no-repeat",
								backgroundSize: "contain"
							}}>
							</MDBCol>
							<MDBCol size="7" className="mt-4" style={{color: "#0e0e0e"}}>
								<MDBCardBody>
									<h2 className="h1-responsive font-weight-bold" style={{textTransform: "uppercase"}}>
										{this.state.title}
									</h2>
									<div className="h4-responsive">
										{this.state.author}
									</div>
									<div className="h5-responsive" style={orangeText}>
										{this.state.genres && this.state.genres.map((x)=>{return this.convertCase(x);}).join(", ")}
									</div>
									<div className="py-3">
										<span dangerouslySetInnerHTML={{__html: this.state.description}}/>
									</div>
									<MDBRow>
										<MDBCol size="6">
											Publisher:
											<div className="h4-responsive" style={orangeText}>
											{this.state.publisher}
											</div>
										</MDBCol>
										<MDBCol size="6">
											Year of Release:
											<div className="h4-responsive" style={orangeText}>
											{this.state.releaseYear}
											</div>
										</MDBCol>
									</MDBRow>
									<MDBRow>
										<MDBCol size="6">
											Pages:
											<div className="h4-responsive" style={orangeText}>
											{this.state.num_pages}
											</div>
										</MDBCol>
										<MDBCol size="6">
											Rating:
											<div className="h4-responsive" style={orangeText}>
											{this.state.rating && this.state.rating.toFixed(2)}/5
											</div>
										</MDBCol>
									</MDBRow>
									<div className="d-flex justify-content-center">
										<Star/>
									</div>
								</MDBCardBody>
							</MDBCol>
						</MDBRow>
					</MDBCard>
				</div>
			</MDBView>
		)
	}
}
export default BookPage;