import CaseStudy from "./landing/components/CaseStudy";
import FAQ from "./landing/components/FAQ";
import Features from "./landing/components/Features";
import Footer from "./landing/components/Footer";
import Header from "./landing/components/Header";
import Hero from "./landing/components/Hero";
import SchemaMarkup from "./landing/components/SchemaMarkup";

export default function RootPage() {
  return (
    <>
      <SchemaMarkup />
      <Header />
      <main className="flex-grow">
        <Hero />
        <Features />
        <CaseStudy />
        <FAQ />
      </main>
      <Footer />
    </>
  );
}
